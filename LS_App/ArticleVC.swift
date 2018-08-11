//
//  ArticleVC.swift
//  LS_App
//
//  Created by Boocha on 03.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import WebKit

class ArticleVC: UIViewController {
    
    @IBOutlet weak var velkyObrazek: UIImageView!
    
    @IBOutlet weak var obsahLabel: UILabel!
    var url: String?

    var velkyObrazekUrl: String? = nil
    var obsahClanku: String? = nil
    
    override func viewDidLoad() {
        
       // obsahLabel.text = obsahClanku
        //velkyObrazek.kf.setImage(with: URL(string: velkyObrazekUrl!))
        
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
