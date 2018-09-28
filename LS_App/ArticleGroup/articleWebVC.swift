//
//  articleWebVC.swift
//  LS_App
//
//  Created by Boocha on 28.09.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import WebKit
import SKActivityIndicatorView


class articleWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate{

    var linkClanku = "www.laskyplnysvet.cz"
    

    @IBOutlet weak var webView: WKWebView!
    

    override func viewDidAppear(_ animated: Bool) {
        
            //postupně vykreslí tmavší pozadí pro loading
            self.view.backgroundColor = .white
            self.view.alpha = 0.8
            SKActivityIndicator.show("Načítám článek")
                    
        
    }
    
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [.curveEaseOut], animations: {
            //postupně vykreslí tmavší pozadí pro loading
            self.view.backgroundColor = .white
            self.view.alpha = 1
            SKActivityIndicator.dismiss()
            
        }, completion: nil)
        
    }
    

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let preferences = WKPreferences()
        //preferences.javaScriptEnabled = true
        //let configuration = WKWebViewConfiguration()
        //configuration.preferences = preferences
        
        //webView = WKWebView(frame: view.bounds, configuration: configuration)
        //view.addSubview(webView)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        
        
        
        webView.scrollView.contentInset = UIEdgeInsetsMake(-310, 0, 0, 0)
        
        let url = URL(string: linkClanku)
        let urlRequest = URLRequest(url: url!)
        
        webView.load(urlRequest)
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SKActivityIndicator.dismiss()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
