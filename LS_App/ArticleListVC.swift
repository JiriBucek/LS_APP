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

class ArticleListVC: UIViewController, UITabBarDelegate, UITableViewDataSource {
    //VC, který zobrazuje seznam článků
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    let APIadresa = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/posts"
    
    var articlesArray: [ArticleClass]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadArticles(APIurl: APIadresa)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadArticles(APIurl: String){
        //pripoji se k API, vyzobe si z JSONa, co potrebuje a vytvori objekty pro Articl esarray
            Alamofire.request(APIadresa).responseJSON{response in
            
            if let value = response.result.value as? [Dictionary<String, Any>]{
            
            for item in value{
                //Doplnit podminky proti crashi
                let article = ArticleClass()
                
                let json = JSON(item)
                
                if let nadpis = json["title"]["rendered"].string{
                    
                    //let nadpis2 = NSAttributedString(string: nadpis)
                    article.nadpis = nadpis
                }
                
                
                if let popisek = json["excerpt"]["rendered"].string{
                    //let popisek2 = NSAttributedString(string: popisek)
                    article.popisek = popisek
                }
                
                if let obsahClanku = json["content"]["rendered"].string{
                    article.obsahClanku = obsahClanku
                }
                
                if let mediaId = json["featured_media"].string{
                    article.mediaId = mediaId
                }
                
                
                /*
                if let nadpis = item["title"] as? NSDictionary{
                    let nadpis2 = nadpis["rendered"]
                    article.nadpis = nadpis2 as? String
                }else{
                    print("Nerozparsuju JSON")
                }
                
                if let popis = item["excerpt"] as? NSDictionary{
                    let popis2 = popis["rendered"]
                    article.popisek = popis2 as? String
                }
                
                if let content = item["content"] as? NSDictionary{
                    let content2 = content["rendered"]
                    article.obsahClanku = content2 as? String
                }*/
                
                self.articlesArray?.append(article)
                }
                
               // DispatchQueue.main.async {
                    self.articlesTableView.reloadData()
                    //reloaduje pokazde data pro tableview
                //}
                
            }
            
         
        }
    }
    
    
    
    
    //MARK: - funkce protokolů pro TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //povinná funkce protokolu UITAbleViewDataSource. Využívá identifieru, který jsem nastavil ve vlastnostech buňky
        
        let cell = articlesTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        let barva = UIColor.blue
        
        cell.nadpisLabel.attributedText = self.articlesArray?[indexPath.item].nadpis?.htmlAttributed(family: "Avenir", size: 16, color: barva)
        cell.popisekLabel.attributedText = self.articlesArray?[indexPath.item].popisek?.htmlAttributed(family: "Avenir", size: 12, color: barva)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //sekce rozdělují celly do skupin. Potřebuju jen jednu.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articlesArray?.count ?? 0
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


extension UIImageView{
    //umi si stahnout obrazek
    func downloadObrazek(mediaId: String) -> (String, String){
        
        let mediaUrl = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/media/" + mediaId
        Alamofire.request(mediaUrl).responseJSON{response in
            
            if let odpoved = response.result.value as? NSDictionary{
                
                let json = JSON(odpoved)
                
                let malyObrazekUrl = json["mediadetails"]["sizes"]["thumbnail"]["source_url"].string
                let velkyObrazekUrl = json["mediadetails"]["sizes"]["full"]["source_url"].string
            }
            
        }
    return(malyObrazekUrl, velkyObrazekUrl)
    }
    
    
}


extension String {
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #\(color.hexString!) !important;" +
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

extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            print(components)
            let r = components[0]
            let g = components[1]
            var b: CGFloat
            if components.count > 2{
                b = components[2]
            }else{
                b = 0
            }
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}

/*
extension UIImageView{
    //Přidává funkci stáhnutí si obrázku k článku
    
    func stahniObrazek(id_clanku: Int){
        let idClankuString = String(id_clanku)
        let URL = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/media/" + idClankuString
        
        Alamofire.request(URL).responseJSON{response in
            
            if let value = response.result.value as? [Dictionary<String, Any>]{
            
                    }
                    article.nadpis = nadpis2 as? String
                }else{
                    print("Nerozparsuju JSON")
                }
                
            }
        }
        
    
    }
    
    
}*/
