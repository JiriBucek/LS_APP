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
    
    
    @IBAction func odhlasitBtnPrsd(_ sender: Any) {
        
        if KeychainWrapper.standard.string(forKey: "userName") != nil{
            print("jsem tu")
            KeychainWrapper.standard.removeObject(forKey: "userName")
            KeychainWrapper.standard.removeObject(forKey: "passWord")
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
        
        
        let email = KeychainWrapper.standard.string(forKey: "userName")
        
        if email != nil{
            emailLabel.text = email
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
