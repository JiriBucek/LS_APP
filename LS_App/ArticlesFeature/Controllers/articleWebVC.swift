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
import NVActivityIndicatorView


class articleWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate{

    var linkClanku = "www.laskyplnysvet.cz"
    
    @IBOutlet weak var spinnerView: NVActivityIndicatorView!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var loadingClanekView: UIView!
    @IBOutlet weak var pozadiView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        webView.scrollView.contentInset = UIEdgeInsetsMake(-310, 0, 0, 0)
        
        self.webView!.isOpaque = false
        self.webView!.backgroundColor = UIColor.clear
        self.webView!.scrollView.backgroundColor = UIColor.clear
        
        
        spinnerView.startAnimating()
        loadingClanekView.isHidden = false
        loadingClanekView.layer.cornerRadius = 15
        loadingClanekView.clipsToBounds = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
            //postupně vykreslí tmavší pozadí pro loading
        
        if webView.isLoading{
            
            //self.view.backgroundColor = .white
            //self.view.alpha = 0.8
            pozadiView.isHidden = false
            pozadiView.alpha = 1
    
            
            //pozadiView.image = #imageLiteral(resourceName: "uvod.png")
            //SKActivityIndicator.show("Načítám článek")
        }
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            //předává informaci progress view o tom, kolik je načteno stránky,
    }
    
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if progressView.progress > 0.6{
                
                UIView.animate(withDuration: 0.1, delay: 0.5, options: [.curveEaseOut], animations: {
                    //postupně vykreslí tmavší pozadí pro loading
                    //self.view.backgroundColor = .white
                    //self.view.alpha = 1
                    //SKActivityIndicator.dismiss()
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
        if navigationAction.targetFrame == nil {
            //zajišťuje otvírání odkazů v rámci WKwebView, bez ní nefungují
            
            webView.load(navigationAction.request)
            
            let odkaz = navigationAction.request.url?.absoluteString
            //pokud je nový odkaz na serveru laskyplnysvet, tak se posune zobrazeni a tim se schova menu
            if odkaz?.range(of: "laskyplnysvet") == nil{
                webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                webView.scrollView.contentInset = UIEdgeInsetsMake(-310, 0, 0, 0)
            }
            
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
        //SKActivityIndicator.dismiss()
        spinnerView.stopAnimating()
        loadingClanekView.isHidden = true
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
