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

    @IBOutlet weak var textView: UITextView!

    
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
    
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.layer.borderColor = UIColor(red: 46/255,
                                                       green: 111/255,
                                                       blue: 162/255,
                                                       alpha: 1).cgColor
            registerButton.layer.borderWidth = 1
            registerButton.layer.cornerRadius = registerButton.bounds.height / 2
        }
    }

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
        setupTextView()
    }

    private func setupTextView() {


        let text =  """
            Pro přihlášení je zapotřebí se zaregistrovat. V emailu poté nalezneš přihlašovací údaje, kterými se v této aplikaci přihlásíš.\n\nNové audiomeditace získáš na https://laskyplnysvet.cz/audiomeditace.\n\nNemůžeš v aplikaci nalézt tebou zakoupené audiomeditace? Pak nám napiš na muj@laskyplnysvet.cz a vše rychle vyřešíme :).\n\nTvoř svůj svět.
            """
        textView.text = text
    }
}
