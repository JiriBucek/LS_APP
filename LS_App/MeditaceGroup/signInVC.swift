import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var prihlasitBtn: UIButton!
    
    
    var userName: String?
    var userPassword: String?
    var myActivityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        userNameTextField.layer.cornerRadius = userNameTextField.frame.size.height/2
        userNameTextField.clipsToBounds = true
        userNameTextField.layer.borderWidth = 0.5
        
        userPasswordTextField.layer.cornerRadius = userPasswordTextField.frame.size.height/2
        userPasswordTextField.clipsToBounds = true
        userPasswordTextField.layer.borderWidth = 0.5
        
        prihlasitBtn.layer.cornerRadius = 25
        prihlasitBtn.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        // Read values from text fields
        userName = userNameTextField.text
        userPassword = userPasswordTextField.text
        
        // Check if required fields are not empty
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            // Display alert message here
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "Doplň přihlašovací údaje prosím.")
            
        }
        
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        signInRequest()
        
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Chyba", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }


func signInRequest(){
    print("Začínám request")
    let myUrl = URL(string: "https://www.ay.energy/api/media/login/")
    var request = URLRequest(url:myUrl!)
    
    request.httpMethod = "POST"// Compose a query string
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    
    var postString = [String:String]()
    if userName != nil, userPassword != nil{
        postString = ["username": userName!, "password": userPassword!] as [String: String]
    }else{
        print("Poststring: ", postString)
    }
        
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
        displayMessage(userMessage: "Něco se pokazilo.")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401{
                self.displayMessage(userMessage: "Chybné přihlašovací údaje")
                self.removeActivityIndicator(activityIndicator: self.myActivityIndicator)
                return
            }
        }
        
        self.removeActivityIndicator(activityIndicator: self.myActivityIndicator)
        
        if error != nil
        {
            self.displayMessage(userMessage: "Nelze ověřit identitu uživatele. Prosím zkus později.")
            print("error=\(String(describing: error))")
            return
        }
        
        //Let's convert response sent from a server side code to a NSDictionary object:
        
        if data != nil{
            let downloadedJSON = JSON(data!)
            print(downloadedJSON)
            if let token = downloadedJSON["body"]["token"].string{
                print("Token: ", token)
                let saveAccessToken: Bool = KeychainWrapper.standard.set(token, forKey: "accessToken")
                print("Token uložen do klíčenky: ", saveAccessToken)
                
                let saveUserName: Bool = KeychainWrapper.standard.set(self.userName!, forKey: "userName")
                print("Email uložen do klíčenky: ", saveUserName)
                
                let savePassWord: Bool = KeychainWrapper.standard.set(self.userPassword!, forKey: "passWord")
                print("Heslo uloženo do klíčenky: ", savePassWord)
                
                // Až získám token, přesměruji se na seznam meditací
                DispatchQueue.main.async{
                //další VC můžu volat jen na hlavním threadu. Proto to musím. 
                    
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
    
    
    
}



