//
//  ViewController.swift
//  LS_App
//
//  Created by Boocha on 24.07.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
/*
Animace samostatného indikátoru
 
let frame = CGRect(x: 0.0 , y: 150.0 , width: 100, height: 100)
let activityIndicatorView = NVActivityIndicatorView(frame: frame, color: .black)
self.view.addSubview(activityIndicatorView)
activityIndicatorView.startAnimating()
*/
