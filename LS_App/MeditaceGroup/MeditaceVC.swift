//
//  MeditaceVC.swift
//  LS_App
//
//  Created by Boocha on 17.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import Foundation
import SwiftyUserDefaults
import NVActivityIndicatorView
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import Kingfisher



class MeditaceVC: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var overallLoadingView: UIView!
    
    @IBOutlet weak var spinnerView: NVActivityIndicatorView!
    
    var userName: String?
    var userPassWord: String?
    var token = ""
    
    var meditaceArray:[MeditaceClass]? = []
    
    @IBAction func refreshBtn(_ sender: Any) {
        Defaults.removeAll()
        meditaceTableView.reloadData()
        
    }
    
    
    @IBOutlet weak var meditaceTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        if NetworkReachabilityManager()!.isReachable{
        
        
            spinnerView.startAnimating()
            
            if checkKlicenka(){
                print("V klíčence jsou login údaje.")
                performDoubleRequest()
            }else{
                loadSignInVC()
                print("V klíčence nejsou login údaje, načítám přihlaěovací obrazovku.")
            }
            
            print("Not first launch: ", Defaults[.notFirstLaunch]!)

        }else{
            displayMessage(userMessage: "K přehrávání meditací je zapotřebí připojení k internetu.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.isNavigationBarHidden = true
        
        if !Defaults[.notFirstLaunch]!{
            // co se stane při prvním spuštění
            Defaults[.notFirstLaunch] = true
            Defaults[.meditace1] = true
            Defaults[.meditace2] = false
            Defaults[.meditace3] = true
            Defaults[.meditace4] = false
            Defaults[.meditace5] = true
        }
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadMeditationData(jsonData: JSON){
        
            for item in jsonData["body"]{
                let meditaceObjekt = MeditaceClass()
                
                meditaceObjekt.id = item.1["id"].int
                meditaceObjekt.nadpis = item.1["title"].string
                meditaceObjekt.obsah = item.1["description"].string
                meditaceObjekt.obrazekUrl = item.1["imageUrl"].string
                meditaceObjekt.cena = item.1["price."].int
                meditaceObjekt.velikost = item.1["size"].int64
                meditaceObjekt.dostupnost = item.1["isAvailable"].bool
                
                meditaceArray?.append(meditaceObjekt)
 
            }
            
            meditaceTableView.reloadData()
            overallLoadingView.isHidden = true
            spinnerView.stopAnimating()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meditaceTableView.dequeueReusableCell(withIdentifier: "meditaceCell", for: indexPath) as! MeditaceCell
        
        cell.nadpisCellMeditace.text = self.meditaceArray?[indexPath.item].nadpis
        cell.popisekCellMeditace.text = self.meditaceArray?[indexPath.item].obsah
        //let jmenoObrazku = self.meditaceArray?[indexPath.item].obrazekName
        
        //print(Defaults.bool(forKey: meditaceId!))
        /*
        if (Defaults.bool(forKey: meditaceId!) == true){
        cell.obrazekMalyMeditace.image = UIImage(imageLiteralResourceName: jmenoObrazku!)
        }else{
            cell.obrazekMalyMeditace.image = #imageLiteral(resourceName: "locked.png")
        }
        */
        cell.obrazekMalyMeditace.layer.cornerRadius = 5
        cell.obrazekMalyMeditace.clipsToBounds = true
        if let obrazekURL = URL(string: (self.meditaceArray?[indexPath.item].obrazekUrl)!){
            let resource = ImageResource(downloadURL: obrazekURL)
            cell.obrazekMalyMeditace.kf.setImage(with: resource)
            
            if !(self.meditaceArray?[indexPath.item].dostupnost)!{
                cell.vrchniObrazek.image = #imageLiteral(resourceName: "locked.png")
                cell.obrazekMalyMeditace.alpha = 0.4
            }else{
                cell.vrchniObrazek.image = nil
                cell.obrazekMalyMeditace.alpha = 1
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let detailMeditaceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meditaceDetail") as! DetailMeditaceVC
        
        detailMeditaceVC.nadpis = self.meditaceArray?[indexPath.item].nadpis
        detailMeditaceVC.obsah =  self.meditaceArray?[indexPath.item].obsah
        detailMeditaceVC.obrazekUrl = self.meditaceArray?[indexPath.item].obrazekUrl
        detailMeditaceVC.id = self.meditaceArray?[indexPath.item].id
        detailMeditaceVC.dostupnost = self.meditaceArray?[indexPath.item].dostupnost
        
        self.navigationController?.pushViewController(detailMeditaceVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meditaceArray?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func checkKlicenka() -> Bool{
        //jsou k dispozici prihlasovaci udaje?
        
        userName = KeychainWrapper.standard.string(forKey: "userName")
        userPassWord = KeychainWrapper.standard.string(forKey: "passWord")
            
            if userName != nil || userPassWord != nil{
                return true
            }else{
                return false
            }
    }
    
    
    
    
    func performDoubleRequest(){
        // nejdříve zjistí token na základě přihlašovacích údajů a následně stáhne seznam meditací
        //TOKEN REQUEST
        
        
        let url = URL(string: "https://www.ay.energy/api/media/login")
        let parameters: Parameters = ["username" : userName!, "password" : userPassWord!]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300)
            .responseData{ response in
                
                switch response.result{
                case .success:
                    
                    let downloadedJSON = JSON(response.data!)
                    self.token = downloadedJSON["body"]["token"].string as! String
                    let saveAccessToken: Bool = KeychainWrapper.standard.set(self.token, forKey: "accessToken")
                    print("Token uložen do klíčenky: ", saveAccessToken)
                    self.meditationListRequest()
                    
                case .failure:
                    print("Error při requestu o token.")
                    print(response.result)
                    print(response.response!)
                }
        }
    }
        
    func meditationListRequest(){
        
            //stáhnu data meditací
            let urlMeditace = URL(string: "https://www.ay.energy/api/media/meditations")
        
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(String(describing: token))",
                "Accept": "application/json"
            ]
            
            Alamofire.request(urlMeditace!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300)
                .responseData() { response in
                    
                    switch response.result{
                        
                    case .success:
                        do{
                            let json = try JSON(data: response.data!, options: .mutableContainers)
                            self.loadMeditationData(jsonData: json)
                        }catch{
                            print("Nepodařilo se převést data na json.")
                            print("Data: ", response.data!)
                            print("Status code: ", response.response?.statusCode as Any)
                        }
                        
                    case .failure:
                        print("Failed request. Načítám přihlašovací screen.")
                        print("Status code: ", response.response?.statusCode as Any)
                        print("Response: ", response.response as Any)
                        //načti přihlašovací obrazovku
                        self.loadSignInVC()
                    }
                    
                }
    }
    
    func loadSignInVC(){
        let signInVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVc") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
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

extension DefaultsKeys {
    // NSUserDefaults keys pro SwiftyUserDefaults
    // https://cocoapods.org/pods/SwiftyUserDefaults
    
    static let notFirstLaunch = DefaultsKey<Bool?>("notFirstLaunch")

    static let meditace1 = DefaultsKey<Bool?>("meditace1")
    static let meditace2 = DefaultsKey<Bool?>("meditace2")
    static let meditace3 = DefaultsKey<Bool?>("meditace3")
    static let meditace4 = DefaultsKey<Bool?>("meditace4")
    static let meditace5 = DefaultsKey<Bool?>("meditace5")
    
    
}

