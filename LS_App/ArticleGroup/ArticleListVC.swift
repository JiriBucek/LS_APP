//
//  ArticleListVC.swift
//  LS_App
//
//  Created by Boocha on 24.07.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher
import NVActivityIndicatorView
import SKActivityIndicatorView

class ArticleListVC: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    //VC, který zobrazuje seznam článků
    
    @IBOutlet weak var articlesTableView: UITableView!
    

    
    
    
    let APIadresa = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/posts?per_page=20&offset=0&_embed=true"
    
    var articlesArray: [ArticleClass]? = []
    
    @IBOutlet weak var loadingView: UIImageView!
    var loadingMore = false
    //Stahuju zrovna další články


    @IBOutlet weak var loadingLabel: UILabel!
    var activityIndicatorView: NVActivityIndicatorView? = nil
    //indikátor načítání prvtních článků
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //displayInfo(infoText: "Načítám články...")
        //Loading bar
        SKActivityIndicator.show("Načítám články")
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        articlesTableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        
        loadArticles(APIurl: APIadresa)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    
    func loadArticles(APIurl: String){
        //pripoji se k API, vyzobe si z JSONa, co potrebuje a vytvori objekty pro Articl esarray
        
        loadingMore = true
        articlesTableView.reloadSections(IndexSet(integer: 1), with: .none)
        //reloadne spinner section
            let asyncObsah = DispatchQueue.main
            print("NOVÝ REQUEST")
            Alamofire.request(APIurl).responseJSON{response in
            print("MÁM DATA")
                
            if let value = response.result.value as? [Dictionary<String, Any>]{
            var poradi = 1
                
            for item in value{
                
                let article = ArticleClass()
                
                let json = JSON(item)
                
                if let nadpis = json["title"]["rendered"].string{
                    //article.nadpis = nadpis.htmlAttributed()?.string
                    article.nadpis = nadpis.htmlAttributed(family: "Avenir", size: 15, color: .black)?.string
                    print("1 " + nadpis)
                }
    
                asyncObsah.async {
                if let obsah = json["content"]["rendered"].string{
                    article.obsah = obsah
                    
                    //article.obsah = obsah.htmlAttributed(family: "Avenir", size: 15, color: .black)
                    print("2." + "\(poradi)")
                    poradi += 1
                }
 
                
                }
 
                if let popisek = json["excerpt"]["rendered"].string{
                    //article.popisek = popisek.htmlAttributed()?.string
                    article.popisek = popisek.htmlAttributed(family: "Avenir", size: 15, color: .black)?.string
                    print(3)
                }
                
               /*if let linkClanku = json["link"].string{
                    article.linkClanku = linkClanku
                }*/

                
                if let malyObrazekUrl = json["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"].string{
                   article.obrazekURL = malyObrazekUrl
                    print(4)
               }
                
                if let velkyObrazekURL = json["_embedded"]["wp:featuredmedia"][0]["source_url"].string{
                    article.velkyObrazekURL = velkyObrazekURL
                    print(5)
                }

               /*self.getObrazekURL(mediaId: String(article.mediaId!)){malyObrazekUrl, velkyObrazekUrl in
                    //nacita URL adresu thumbnail obrazku a velkeho obrazku
                    //jede asynchronne a data v table view se reloadnou teprve, az je nacteno vse
                    
                    if let encodedUrl = malyObrazekUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encodedUrl){
                        //dekodovani Stringu s URL kvuli diakritice
                        article.downloadedImageResource = ImageResource(downloadURL: url, cacheKey: encodedUrl)
                    }else{
                        print("Nepodařilo se dekodovat URL")
                    }
                    
                    
                    article.velkyObrazekURL = velkyObrazekUrl
                    
                    if article == self.articlesArray?.last{
                        self.articlesTableView.reloadData()
                        self.hideInfo()
                        self.loadingMore = false
                    }
                }
                */
                self.articlesArray?.append(article)
                
                print(6)
                //let index = IndexPath.init(row: (self.articlesArray?.count)! - 1, section: 0)
                //self.articlesTableView.reloadRows(at: [index], with: .fade)
  

                }
                
                self.articlesTableView.reloadData()
                //self.hideInfo()
                SKActivityIndicator.dismiss()
                self.loadingView.isHidden = true
                self.loadingMore = false

                print("konec")

            }
        }
    }
    
    
    
    
    //MARK: - funkce protokolů pro TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //povinná funkce protokolu UITAbleViewDataSource. Využívá identifieru, který jsem nastavil ve vlastnostech buňky
        if indexPath.section == 0{
        
        let cell = articlesTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.nadpisLabel.text = self.articlesArray?[indexPath.item].nadpis
        cell.popisekLabel.text = self.articlesArray?[indexPath.item].popisek
            
        cell.obrazekView.layer.cornerRadius = 5
        cell.obrazekView.clipsToBounds = true
        
        //let backgroundTasks = DispatchQueue.main
            
        cell.obrazekView.layer.cornerRadius = 5
        cell.obrazekView.clipsToBounds = true
        //oblé rohy
            
        if self.articlesArray?[indexPath.item].obrazekURL != nil{
            
            if let encodedUrl = self.articlesArray?[indexPath.item].obrazekURL?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encodedUrl){
                
                let resource = ImageResource(downloadURL: url)
                cell.obrazekView.kf.setImage(with: resource)
            }
        }else{
            cell.obrazekView.image = #imageLiteral(resourceName: "LS_logo_male")
            }
    
            
        return cell
            
        }else{
            let cell = articlesTableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //sekce rozdělují celly do skupin. Potřebuju jen jednu.
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
        return self.articlesArray?.count ?? 0
            
        }else if section == 1 && loadingMore{
            //tohle je sekce pro loading spinner
            return 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let clanekVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! ArticleVC
        let cell = tableView.cellForRow(at: indexPath)
    
        
        
        UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseOut], animations: {

            self.view.backgroundColor = .white
            self.view.alpha = 0.6
            SKActivityIndicator.show()

        }, completion: nil)
        

        
        clanekVC.obsahClanku = self.articlesArray?[indexPath.item].obsah?.htmlAttributed(family: "Avenir", size: 15, color: .black)
        clanekVC.velkyObrazekUrl = self.articlesArray?[indexPath.item].velkyObrazekURL
        clanekVC.nadpisClanku = self.articlesArray?[indexPath.item].nadpis
        loadingMore = false
       // self.present(clanekVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(clanekVC, animated: true)
        self.view.alpha = 1
        SKActivityIndicator.dismiss()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articlesArray!.count - 1 && loadingMore == false {
            print("POSLEDNI")
            // we are at last cell load more content
            // we need to bring more records as there are some pending records available
        if let offset = articlesArray?.count{
            loadArticles(APIurl: "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/posts?per_page=10&offset=\(offset)&_embed=true")
        //self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
        }
        }
    }
    
    

    /*func getObrazekURL(mediaId: String, completion: @escaping ((String, String) -> ())){
        //propoji se k dalši APIně, stáhne si JSONa a vyzobe z něj URL na obrázky. Nakonec toto URL předá closure completion jako její parametr. Protože stahování URL probíhá asynchronně, nelze normálně returnovat, ale na konci prostě řeknu: proveď tento kód s tímto parametrem. Při voláni funkce pak vytvořím samotnou closure. 
        
        let mediaUrl = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/media/" + mediaId
        var malyObrazekUrl: String?
        var velkyObrazekUrl: String?
        
        Alamofire.request(mediaUrl).responseJSON{response in
            if let odpoved = response.result.value as? NSDictionary{
                
                let json = JSON(odpoved)
                malyObrazekUrl = json["media_details"]["sizes"]["thumbnail"]["source_url"].string
                velkyObrazekUrl = json["media_details"]["sizes"]["full"]["source_url"].string
                
                
                if malyObrazekUrl != nil, velkyObrazekUrl != nil{
                    completion(malyObrazekUrl!, velkyObrazekUrl!)
                }
            }
        }
    }*/
    
    func displayInfo(infoText: String){
        //Zobrazí loading animaci a label
        loadingView.backgroundColor = UIColor(white: 1, alpha: 1)

        let bodX = UIScreen.main.bounds.width
        let bodY = UIScreen.main.bounds.height
        let frame = CGRect(x: bodX/2 - 25  , y: bodY/2 - 25 , width: 50  , height: 50)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .lineScale, color: .black)
        self.view.addSubview(activityIndicatorView!)
        
        activityIndicatorView?.startAnimating()
        loadingLabel.isHidden = false
        loadingLabel.center.x = bodX/2
        loadingLabel.center.y = bodY/2 + 50
        loadingLabel.text = infoText
    }
    
    func hideInfo(){
        activityIndicatorView?.stopAnimating()
        loadingView.isHidden = true
        loadingLabel.isHidden = true
    }
    
    
    func showActivityIndicatory(uiView: UIView) {
        var container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = .white
        container.alpha = 0.3
        
        var loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.9
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
        var cellSpinner: UIActivityIndicatorView = UIActivityIndicatorView()
        cellSpinner.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        cellSpinner.hidesWhenStopped = true
        cellSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(cellSpinner)
        cellSpinner.startAnimating()
        
        
        /*
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.hidesWhenStopped = true
        actInd.startAnimating()
        */
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


/*
extension String {
    //Dokáže přetvořit text s html tagy na normální text
    func htmlAttributed() -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html * {font-size: 15.0pt !important;color: #383838 !important;font-family: Avenir !important;}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("html error: ", error)
            return nil
        }
    }
    
}
*/


extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var htmlAttributed: (NSAttributedString?, NSDictionary?) {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return (nil, nil)
            }
            
            var dict:NSDictionary?
            dict = NSMutableDictionary()
            
            return try (NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html,
                                                     .characterEncoding: String.Encoding.utf8.rawValue],
                                           documentAttributes: &dict), dict)
        } catch {
            print("error: ", error)
            return (nil, nil)
        }
    }
    
    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize)pt !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
}


