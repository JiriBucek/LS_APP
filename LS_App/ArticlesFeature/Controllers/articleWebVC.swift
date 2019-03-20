//
//  articleWebVC.swift
//  LS_App
//
//  Created by Boocha on 28.09.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView


class articleWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate{
    //  VC zobrazující obsah článku ve WKWebView
    
    var linkClanku = "www.laskyplnysvet.cz"
    
    @IBOutlet weak var spinnerView: NVActivityIndicatorView!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var loadingClanekView: UIView!
    @IBOutlet weak var pozadiView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        webView.scrollView.contentInset = UIEdgeInsets.init(top: -310, left: 0, bottom: 0, right: 0)
        
        self.webView!.isOpaque = false
        self.webView!.backgroundColor = UIColor.clear
        self.webView!.scrollView.backgroundColor = UIColor.clear
        
        
        spinnerView.startAnimating()
        loadingClanekView.isHidden = false
        loadingClanekView.layer.cornerRadius = 15
        loadingClanekView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if webView.isLoading{
            pozadiView.isHidden = false
            pozadiView.alpha = 1
        }
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            //  Předává informaci progress view o tom, kolik je načteno stránky,
    }
    
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Vykreslí článek při načtení 60% obsahu.
        
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if progressView.progress > 0.6{
                
                UIView.animate(withDuration: 0.1, delay: 0.5, options: [.curveEaseOut], animations: {
                    self.spinnerView.stopAnimating()
                    self.loadingClanekView.isHidden = true
                    self.pozadiView.isHidden = true
                }, completion: nil)
            }
            
            if progressView.progress != 1{
                progressView.isHidden = false
            }
            
            if progressView.progress == 1{
                progressView.isHidden = true
                progressView.progress = 0
            }
        }
    }
    

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //  Zajišťuje otvírání odkazů v rámci WKwebView, bez této funkce nefungují.
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
            
            let odkaz = navigationAction.request.url?.absoluteString
            
            //  Pokud je nový odkaz na serveru laskyplnysvet, tak se posune zobrazeni a tim se schova horní menu.
            if odkaz?.range(of: "laskyplnysvet") == nil{
                webView.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }else{
                webView.scrollView.contentInset = UIEdgeInsets.init(top: -310, left: 0, bottom: 0, right: 0)
            }
            
        }
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        
        webView.scrollView.contentInset = UIEdgeInsets.init(top: -310, left: 0, bottom: 0, right: 0)
        
        let url = URL(string: linkClanku)
        let urlRequest = URLRequest(url: url!)
        
        webView.load(urlRequest)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        spinnerView.stopAnimating()
        loadingClanekView.isHidden = true
    }
}
