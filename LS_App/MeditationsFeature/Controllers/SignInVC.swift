import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController, UITextFieldDelegate {
    //  VC pro zadání přihlašovacích údajů. 
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var prihlasitBtn: UIButton!
    
    @IBAction func bezregistraceBtn(_ sender: Any) {
        let meditaceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meditaceVC") as! MeditaceVC
        self.navigationController?.pushViewController(meditaceVC, animated: true)
    }
    
    @IBAction func registraceBtn(_ sender: Any) {
    // Plan B registration implementation
    //UIApplication.shared.open(URL(string: "http://www.laskyplnysvet.cz/audiomeditace")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        userName = userNameTextField.text
        userPassword = userPasswordTextField.text
        
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            displayMessage(userMessage: "Doplň přihlašovací údaje prosím.")
        }
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        signInRequest()
    }
    
    var userName: String?
    var userPassword: String?
    var myActivityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        userNameTextField.layer.cornerRadius = userNameTextField.frame.size.height/2
        userNameTextField.clipsToBounds = true
        userNameTextField.layer.borderWidth = 0.5
        
        userPasswordTextField.layer.cornerRadius = userPasswordTextField.frame.size.height/2
        userPasswordTextField.clipsToBounds = true
        userPasswordTextField.layer.borderWidth = 0.5
        
        prihlasitBtn.layer.cornerRadius = 25
        prihlasitBtn.clipsToBounds = true
        
        //  Delegate pro schování klávesnice po kliknutí na return nebo mimo klávesnici.
        self.userNameTextField.delegate = self
        self.userPasswordTextField.delegate = self
    }
    
    func displayMessage(userMessage:String) -> Void {
        //  Zobrazování upozornění
        DispatchQueue.main.async{
                let alertController = UIAlertController(title: "Upozornění", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    DispatchQueue.main.async{
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
        // Schová activity spinner.
    {
        DispatchQueue.main.async{
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }


func signInRequest(){
    //  Funkce pro přihlašování.
    let myUrl = URL(string: "http://68.183.64.160/api/media/login/")
    var request = URLRequest(url:myUrl!)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    var postString = [String:String]()
    if userName != nil, userPassword != nil{
        postString = ["username": userName!, "password": userPassword!] as [String: String]
    }else{
        print("Username nebo password jsou nil a poststring tím pádem neexistuje.")
    }
        
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
        displayMessage(userMessage: "Error při vytváření sign in requestu.")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        if let httpResponse = response as? HTTPURLResponse {
            // Špatný login
            if httpResponse.statusCode == 401{
                self.displayMessage(userMessage: "Chybné přihlašovací údaje")
                self.removeActivityIndicator(activityIndicator: self.myActivityIndicator)
                return
            }
        }
        
        self.removeActivityIndicator(activityIndicator: self.myActivityIndicator)
        
        if error != nil{
            self.displayMessage(userMessage: "Nelze ověřit identitu uživatele. Prosím zkus později.")
            print("error při přihlašování=\(String(describing: error))")
            return
        }
        
        if data != nil{
            //  Uspech.
            let downloadedJSON = JSON(data!)
            if let token = downloadedJSON["body"]["token"].string{
                let saveAccessToken: Bool = KeychainWrapper.standard.set(token, forKey: "accessToken")
                print("Token uložen do klíčenky: ", saveAccessToken)
                
                let saveUserName: Bool = KeychainWrapper.standard.set(self.userName!, forKey: "userName")
                print("Email uložen do klíčenky: ", saveUserName)
                
                let savePassWord: Bool = KeychainWrapper.standard.set(self.userPassword!, forKey: "passWord")
                print("Heslo uloženo do klíčenky: ", savePassWord)
                
                // Až získám token, přesměruji se VC seznamu meditací, který stáhne data meditací.
                DispatchQueue.main.async{
                //  Další VC můžu volat jen na hlavním threadu. Proto to musím volat takto. VC pushuju, aby byl v hierarchii navigation controleru.
                    let meditaceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meditaceVC") as! MeditaceVC
                    self.navigationController?.pushViewController(meditaceVC, animated: true)
                }
            }
        }else{
            print("Request nevrátil žádná data.")
        }
    }
    task.resume()
}
    //  Schování lávesnice po kliknutí na return nebo mimo klávesnici
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userPasswordTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        return true
    }
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
