//
//  ArticleVC.swift
//  LS_App
//
//  Created by Boocha on 03.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

class ArticleVC: UIViewController {
    
    @IBOutlet weak var velkyObrazekOutlet: UIImageView!
    
    @IBOutlet weak var nadpisOutlet: UILabel!
    
    @IBOutlet weak var textOutlet: UITextView!
    
    var url: String?

    var velkyObrazekUrl: String? = nil
    var obsahClanku: NSAttributedString? = nil
    var nadpisClanku: String? = nil
    
    override func viewDidLoad() {
        velkyObrazekOutlet.layer.cornerRadius = 15
        velkyObrazekOutlet.clipsToBounds = true
        //kulaté okraje obrázku
        
       if obsahClanku != nil{        
            textOutlet.attributedText = obsahClanku
        }
        
        if velkyObrazekUrl != nil{
            
            if let encodedUrl = velkyObrazekUrl?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encodedUrl){
                
                velkyObrazekOutlet.kf.setImage(with: url)
            }
        }else{
            velkyObrazekOutlet.image = #imageLiteral(resourceName: "LS_logo_male")
        }
        
        if nadpisClanku != nil{
       nadpisOutlet.text = nadpisClanku
        }
        
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
