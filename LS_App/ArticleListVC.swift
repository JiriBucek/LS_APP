//
//  ArticleListVC.swift
//  LS_App
//
//  Created by Boocha on 24.07.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import Alamofire

class ArticleListVC: UIViewController, UITabBarDelegate, UITableViewDataSource {
    //VC, který zobrazuje seznam článků
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    let APIadresa = "https://laskyplnysvet.cz/stesti/wp-json/wp/v2/posts"
    
    var articlesArray = [ArticleClass]()
    
    
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
        //pripoji se k API, rozdeli JSON na arraye a vytvori objekty pro Articles
        Alamofire.request(APIadresa).responseJSON{response in
            
            
            let value = response.result.value as? [Dictionary<String, Any>]
            
            for item in value!{
                //Doplnit podminky proti crashi
                let article = ArticleClass()
                
                let nadpis = item["title"] as! NSDictionary
                let nadpis2 = nadpis["rendered"]
                article.nadpis = nadpis2 as? String
                
                let popis = item["excerpt"] as! NSDictionary
                let popis2 = popis["rendered"]
                article.popisek = popis2 as? String
                
                let content = item["content"] as! NSDictionary
                let content2 = content["rendered"]
                article.obsahClanku = content2 as? String
                
                self.articlesArray.append(article)
            }
         self.articlesTableView.reloadData()
        }
    }
        
        //Connectne se na API a stáhne si JSON, který rozbalí
        /*let URLrequest = URLRequest(url: URL(string: APIurl)!)
        let task = URLSession.shared.dataTask(with: URLrequest) { (data,response,error) in
            
            if error != nil{
                print(error)
                return
            }
            
            do{
                print(data)
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [AnyObject]
                //rozbalí json na dictionaty String:Any
                print(json)
                
            }catch let error{
                print(error)

            }
            
        }
        task.resume()
        */
        
        
    
    
    
    
    
    
    //MARK: - funkce protokolů pro TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //povinná funkce protokolu UITAbleViewDataSource. Využívá identifieru, který jsem nastavil ve vlastnostech buňky
        
        let cell = articlesTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
    
        //cell.nadpisLabel.text = "ahoj"
        
        cell.nadpisLabel.text = self.articlesArray[indexPath.item].nadpis
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //sekce rozdělují celly do skupin. Potřebuju jen jednu.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articlesArray.count
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
