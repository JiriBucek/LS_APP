//
//  InfoVC.swift
//  LS_App
//
//  Created by Boocha on 01.02.19.
//  Copyright © 2019 Boocha. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class InfoVC: UIViewController {
    // VC s info textem ohledně fungování účtu. Zobrazuje, pod jakým mailem je user přihlášen.
    
    @IBAction func odhlasitBtnPrsd(_ sender: Any) {
        //  Odhlásit/přihlásit button
        if KeychainWrapper.standard.string(forKey: "userName") != nil{
            KeychainWrapper.standard.removeObject(forKey: "userName")
            KeychainWrapper.standard.removeObject(forKey: "passWord")
            let meditaceVC = MeditaceVC()
            meditaceVC.setDefaultLogin()
        }
        
        let signInVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVc") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
        
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var odhlasitBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        odhlasitBtn.clipsToBounds = true
        odhlasitBtn.layer.cornerRadius = odhlasitBtn.frame.height/2
        
        if signedIn{
            odhlasitBtn.setTitle("Odhlásit", for: .normal)
        }else{
            odhlasitBtn.setTitle("Přihlásit", for: .normal)
        }
        
        let email = KeychainWrapper.standard.string(forKey: "userName")
        
        if email != nil{
            emailLabel.text = email
            if !signedIn{
                emailLabel.text = "Nepřihlášen"
            }
        }
    }

}
