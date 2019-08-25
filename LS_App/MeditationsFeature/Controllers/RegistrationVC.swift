//
//  RegistrationVC.swift
//  LS_App
//
//  Created by Boocha on 23/08/2019.
//  Copyright © 2019 Boocha. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.layer.cornerRadius = emailTextField.bounds.height / 2
            emailTextField.layer.borderWidth = 0.5
            emailTextField.clipsToBounds = true
        }
    }
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.layer.cornerRadius = 25
            registerButton.clipsToBounds = true
            registerButton.backgroundColor = mojeModra
        }
    }
    @IBOutlet weak var newsletterButton: UIButton! {
        didSet {
            newsletterButton.layer.borderColor = UIColor.black.cgColor
            newsletterButton.layer.borderWidth = 1
            newsletterButton.layer.cornerRadius = 4
            newsletterButton.clipsToBounds = true
            newsletterButton.isSelected = true
            newsletterButton.backgroundColor = .clear
            newsletterButton.setBackgroundImage(UIImage(named: "checkmarkBlack"), for: .selected)
            newsletterButton.setBackgroundImage(UIImage(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        title = "Registrace"

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
       guard let email = emailTextField.text, isValidEmail(emailStr: email) else {
            displayMessage(userMessage: "Pole email musí být vyplněno ve správném formátu.")
            return
        }
        let newsletterAllowed = newsletterButton.isSelected
        
        sendRegistration(email: email, newsletter: newsletterAllowed)
    }
    
    func sendRegistration(email: String, newsletter: Bool) {
        //  Funkce pro přihlašování.
        let myUrl = URL(string: "http://lamethiel.cz/api/media/registration")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["Email": email, "AllowNewsletter" : "\(newsletter)"]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Error při vytváření register requestu.")
            return
        }
        
        displayNetworkConnecting(connecting: true)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil{
                self.displayMessage(userMessage: "Chyba při registraci.")
                print("error při registraci=\(String(describing: error))")
            } else {
                self.displayMessage(userMessage: "Registrace proběhla úspěšně. Heslo Vám bylo zasláno na email.")
            }
            self.displayNetworkConnecting(connecting: false)
        }
        task.resume()
    }
    
    @IBAction func newsletterButtonPressed(_ sender: UIButton) {
        newsletterButton.isSelected = !newsletterButton.isSelected
    }
    
    func displayNetworkConnecting(connecting: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = connecting
            self.registerButton.isEnabled = !connecting
            self.registerButton.backgroundColor = connecting ? UIColor.lightGray : mojeModra
        }
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
                
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
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }

}

extension RegistrationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
}
