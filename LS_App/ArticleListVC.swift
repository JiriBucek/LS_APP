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
                let article = ArticleClass()
                
                let json = JSON(item)
                
                
                if let nadpis = json["title"]["rendered"].string{
                    
                    article.nadpis = nadpis
                }
                
                if let popisek = json["excerpt"]["rendered"].string{
                    article.popisek = popisek
                }
                
                if let obsahClanku = json["content"]["rendered"].string{
                    article.obsahClanku = obsahClanku
                }
                
                if let mediaId = json["featured_media"].int{
                    article.mediaId = String(mediaId)
                }
                
                
                self.articlesArray?.append(article)
                }
                
                
            }
            self.articlesTableView.reloadData()
        }
    }
    
    
    
    
    //MARK: - funkce protokolů pro TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //povinná funkce protokolu UITAbleViewDataSource. Využívá identifieru, který jsem nastavil ve vlastnostech buňky
        
        let cell = articlesTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.nadpisLabel.text = self.articlesArray?[indexPath.item].nadpis?.htmlAttributed()?.string
        cell.popisekLabel.text = self.articlesArray?[indexPath.item].popisek?.htmlAttributed()?.string
        
       cell.obrazekView.downloadObrazek(mediaId: (self.articlesArray?[indexPath.item].mediaId)!, velikost: "maly")
        
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
    //umoznuje stahnout obrazek a rovnou ho dohodit jako Image do tohoto view
    
    func downloadObrazek(mediaId: String, velikost: String){
        //Velikost: maly nebo velky
        
        let mediaUrl = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/media/" + mediaId
        var malyObrazekUrl: String?
        var velkyObrazekUrl: String?
        
        Alamofire.request(mediaUrl).responseJSON{response in
            
            if let odpoved = response.result.value as? NSDictionary{
                
                let json = JSON(odpoved)
                malyObrazekUrl = json["media_details"]["sizes"]["thumbnail"]["source_url"].string
                velkyObrazekUrl = json["media_details"]["sizes"]["full"]["source_url"].string
                
                if velikost == "maly", malyObrazekUrl != nil{
                    Alamofire.request(malyObrazekUrl!).responseData{data in
                        if let obrazek = data.result.value{
                            self.image = UIImage(data: obrazek)
                        }
                    }
                }
                
                if velikost == "velky", velkyObrazekUrl != nil{
                    Alamofire.request(velkyObrazekUrl!).responseData{data in
                        if let obrazekVelky = data.result.value{
                            self.image = UIImage(data: obrazekVelky)
                        }
                    }
                }
            }
        }
    }
}


extension String {
    func htmlAttributed() -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
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


