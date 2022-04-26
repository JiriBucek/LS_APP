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


class ArticleListVC: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    //  VC, který zobrazuje seznam článků.
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    @IBAction func refreshBtn(_ sender: Any) {
        articlesArray?.removeAll()
        cancelAllAlamofireRequests()
        loadingSpinner.startAnimating()
        doNotMoveTableView = false
        overallLoadnigView.isHidden = false
        loadArticles(APIurl: APIadresa)
    }
    
    @IBOutlet weak var loadingView: UIImageView!
    
    @IBOutlet weak var overallLoadnigView: UIView!
    
    @IBOutlet weak var loadingSpinner: NVActivityIndicatorView!
    
    
    var loadingMore = false
    //  Stahuju zrovna další články?
    
    let APIadresa = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/posts?per_page=20&offset=0&_fields=link,title,excerpt,featured_media"
    
    var articlesArray: [ArticleClass]? = []
    
    var doNotMoveTableView = true
    var cellHeights: [IndexPath : CGFloat] = [:]
    //  Kvůli plynulosti posouvání tableview
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        articlesTableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        
        if NetworkReachabilityManager()!.isReachable{
            loadingSpinner.startAnimating()
            loadArticles(APIurl: APIadresa)
        }else{
            displayMessage(userMessage: "K zobrazení článků je nutné připojení k internetu.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        //vyčistí requesty
        //cleanRequests()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let penultimateCell = [0, (articlesArray?.count)! - 2] as IndexPath
        //vrátí index předposlední zobrazené buňky
        
        
        if (articlesTableView.indexPathsForVisibleRows?.contains(penultimateCell))!{
            loadMoreArticles()
            //pokud se vrátím na seznam článků a jsem na jeho konci (je zobrazena předposlední buňka), tak vytvořím nový request
        }
        

    }
    
    
    func loadArticles(APIurl: String){
        //pripoji se k API, vyzobe si z JSONa, co potrebuje a vytvori objekty pro Articl esarray
        
        loadingMore = true
        
        //articlesTableView.reloadSections(IndexSet(integer: 1), with: .none)
        
        //reloadne spinner section
            print("NOVÝ REQUEST")
            Alamofire.request(APIurl).responseJSON{response in
            print("MÁM DATA")
            self.loadingMore = false

                
            if let value = response.result.value as? [Dictionary<String, Any>]{
                
            for item in value{
                
                let article = ArticleClass()
                
                let json = JSON(item)
                
                if let nadpis = json["title"]["rendered"].string{
                    article.nadpis = nadpis.htmlAttributed(family: "Avenir", size: 15, color: .black)?.string
                }
    
                /*if let obsah = json["content"]["rendered"].string{
                    //obsah se ulozi jako string. Na attributed string se parsuje az pri rozkliknuti clanku.
                    article.obsah = obsah
                
                }*/
 
                if let popisek = json["excerpt"]["rendered"].string{
                    article.popisek = popisek.htmlAttributed(family: "Avenir", size: 15, color: .black)?.string
                }
                
                if let mediaId = json["featured_media"].int{
                    article.mediaId = "\(mediaId)"
                }
                
                
                let mediaURL = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/media/\(article.mediaId!)?_fields=media_details"
                
                if let linkClanku = json["link"].string{
                    article.linkClanku = linkClanku
                }

                self.articlesArray?.append(article)

                Alamofire.request(mediaURL).responseJSON{response in
                    
                    if let mediaResponse = response.result.value{
                        let mediaJson = JSON(mediaResponse)
                        
                        if let obrazekUrl = mediaJson["media_details"]["sizes"]["thumbnail"]["source_url"].string{
                            self.articlesTableView.beginUpdates()
                            article.obrazekURL = obrazekUrl
                            let rowNumber = self.articlesArray?.index(of: article)!
                            let rowIndexPath = IndexPath(row: rowNumber!, section: 0)
                            self.articlesTableView.reloadRows(at: [rowIndexPath], with: .none)
                            self.articlesTableView.endUpdates()
                            
                        }
                    }
                }
                
                }

                self.articlesTableView.reloadData()
                //shodi Nacitam clanky
                
                self.loadingView.isHidden = true
                self.overallLoadnigView.isHidden = true
                self.articlesTableView.reloadData()
                
                if !self.doNotMoveTableView{
                    let topIndex = IndexPath(row: 0, section: 0)
                    self.articlesTableView.scrollToRow(at: topIndex, at: .top, animated: true)
                    self.doNotMoveTableView = true
                }
            }
        }
    }
    
    
    
    
    //MARK: - funkce protokolů pro TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //povinná funkce protokolu UITAbleViewDataSource. Využívá identifieru, který jsem nastavil ve vlastnostech buňky
        if indexPath.section == 0, (self.articlesArray?.indices.contains(indexPath.item))!{
        //sekce tableview s články
                  
            let cell = articlesTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
            cell.nadpisLabel.text = self.articlesArray?[indexPath.item].nadpis
            cell.popisekLabel.text = self.articlesArray?[indexPath.item].popisek
            
            cell.obrazekView.layer.cornerRadius = 5
            cell.obrazekView.clipsToBounds = true
            
            cell.obrazekView.layer.cornerRadius = 5
            cell.obrazekView.clipsToBounds = true
            //oblé rohy+
            
            if self.articlesArray?[indexPath.item].obrazekURL != nil{
                //obrázek k článku
                cell.obrazekView.alpha = 1
                if let encodedUrl = self.articlesArray?[indexPath.item].obrazekURL?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encodedUrl){
                    
                    let resource = ImageResource(downloadURL: url)
                    cell.obrazekView.kf.setImage(with: resource)
                }
            }else{
                cell.obrazekView.image = #imageLiteral(resourceName: "LS_logo_pruhledne_grey")
                cell.obrazekView.alpha = 0.3
                }
        
            
            return cell
            
        }else{
            //loading cell
            
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
            
        }else if section == 1{
            //tohle je sekce pro loading spinner
            return 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let clanekVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! ArticleWebVC
        

        /*
        UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseOut], animations: {
            //postupně vykreslí tmavší pozadí pro loading
            self.view.backgroundColor = .white
            self.view.alpha = 0.6
            SKActivityIndicator.show()

        }, completion: nil)
 
         */
        
        
        clanekVC.linkClanku = (self.articlesArray?[indexPath.item].linkClanku)!
        
        //self.articlesArray?[indexPath.item].obsah = (self.articlesArray?[indexPath.item].obsah)! + "<em>Některé funkce, jako např. formuláře pro odesílání přihlášek na workshopy, se nemusí v této aplikaci zobrazovat správně. Pokud Vám něco nefunguje jak má, navštivte prosím <a href=\"\(odkazClanku ?? "https://laskyplnysvet.cz/stesti/ty-a-laskyplny-svet/")\">webovou verzi tohoto článku</a></em></p>\n"
        
        //clanekVC.obsahClanku = self.articlesArray?[indexPath.item].obsah?.htmlAttributed(family: "Avenir", size: 15, color: .black)
        //clanekVC.velkyObrazekUrl = self.articlesArray?[indexPath.item].velkyObrazekURL
        //clanekVC.nadpisClanku = self.articlesArray?[indexPath.item].nadpis

        self.navigationController?.pushViewController(clanekVC, animated: true)
        self.view.alpha = 1
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cellHeights[indexPath] = cell.frame.size.height
        
        if indexPath.row == articlesArray!.count - 1 && loadingMore == false {
            print("POSLEDNI")
                // we are at last cell load more content
                // we need to bring more records as there are some pending records available
            
            loadMoreArticles()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 70.0
    }

    func cleanRequests(){
        //vyčistí všechny requesty
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    func loadMoreArticles(){
        if loadingMore == false{
            if let offset = articlesArray?.count{
            doNotMoveTableView = true
            loadArticles(APIurl: "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/posts?per_page=10&offset=\(offset)&_fields=link,title,excerpt,featured_media")
            }
        }
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Upozornění", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
}



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


