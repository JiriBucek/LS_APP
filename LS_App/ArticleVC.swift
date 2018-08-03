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
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: String?

    override func viewDidLoad() {
        
        webView.load(URLRequest(url: URL(string: url!)!))
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   

}
