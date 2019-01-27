import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func APIBtn(_ sender: Any) {
        
        apiRequest(koncovka: "meditations")
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        // Read values from text fields
        var userName = userNameTextField.text
        var userPassword = userPasswordTextField.text
        
        userName = "bucek.jiri@email.cz"
        userPassword = "nt@8908KJ@we"
        // Check if required fields are not empty
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            // Display alert message here
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "One of the required fields is missing")
            
            return
        }
        
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        //Send HTTP Request to perform Sign in
        let myUrl = URL(string: "https://www.ay.energy/api/media/login/")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["username": userName!, "password": userPassword!] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            //Let's convert response sent from a server side code to a NSDictionary object:
            
            if data != nil{
                let downloadedJSON = JSON(data!)
                if let token = downloadedJSON["body"]["token"].string{
                    print("Token: ", token)
                    let saveAccessToken: Bool = KeychainWrapper.standard.set(token, forKey: "accessToken")
                    print("Token uložen do klíčenky: ", saveAccessToken)
                }
            }else{
                print("Request nevrátil žádná data.")
            }
        }
        task.resume()
    }




    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
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
    
    
}


func apiRequest(koncovka: String) -> String?{
    
    var returnJson: String?
    var baseUrl = "https://www.ay.energy/api/media/"
    baseUrl.append(koncovka)
    let url = URL(string: baseUrl)
    print("Url: ", url!)
    
    let token = KeychainWrapper.standard.string(forKey: "accessToken") as! String
    print("Token ve funkci apiRequest: ", token)
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(String(describing: token))",
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().validate(contentType: ["application/json; charset=utf-8"])
                .responseJSON() { response in
                    switch response.result {
                        case .success:
                            print("Success")
                        case .failure( _):
                            print("Failure")
                        }
                }
                .response { response in
                    print("Request: \(String(describing: response.request))")
                    print("Response: \(String(describing: response.response))")
                    print("Error: \(String(describing: response.error))")
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        returnJson = utf8Text
                    }
                }
    return returnJson
}

