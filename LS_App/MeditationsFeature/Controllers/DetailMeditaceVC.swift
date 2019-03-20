//
//  DetailMeditaceVC.swift
//  LS_App
//
//  Created by Boocha on 18.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyUserDefaults
import Kingfisher
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class DetailMeditaceVC: UIViewController {
    //  VC s popisem meditace a možností přehrávání.

    @IBOutlet weak var velkyImageMeditace: UIImageView!
    
    @IBOutlet weak var downloadedImage: UIImageView!
    
    @IBOutlet weak var nadpisMeditaceLabel: UILabel!
    
    @IBOutlet weak var obsahMeditaceLabel: UILabel!
    
    @IBAction func prehrajMeditaciPressed(_ sender: Any) {
        //  Přehraj button mění funkce dle toho: zda je uživatel přihlášen, je k dispozici internet, daná meditace je nakoupena, meditace je stáhnuta nebo bude streamována.
        
        if let dostupnost = dostupnost, let downloaded = downloaded{
            print("Dostupne: \(dostupnost), downloaded: \(downloaded), signed in: \(signedIn), net: \(checkInternet())")
            if checkInternet(){
                if dostupnost{
                    //  Internet ano, meditace zakoupena.
                    let backItem = UIBarButtonItem()
                    backItem.title = "Zpět"
                    navigationItem.backBarButtonItem = backItem
                    meditaceFilesRequest(vcName: "player")
                }else{
                    if signedIn{
                        // Internet ano, meditace nezakoupena, uživatel přihlášen.
                        let url = URL(string: "http://www.laskyplnysvet.cz/audiomeditace")
                            if UIApplication.shared.canOpenURL(url!) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }
                        }else{
                            // Internet ano, meditace nezakoupena, uživatel nepřihlášen.
                            print("SignInVC")
                            loadSignInVC()
                        }
                    }
            }else{
                if downloaded, dostupnost{
                    // Internet ne, meditace stažena, koupena.
                    let newVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "player") as! MeditacePlayerVC
                    newVC.id = self.id!
                    newVC.downloaded = self.downloaded ?? false
                    self.navigationController?.pushViewController(newVC, animated: true)
                }else if dostupnost{
                    // Internet ne, meditace zakoupena, nestažena.
                    displayMessage(userMessage: "K přehrávání meditací online je zapotřebí připojení k internetu. Pokud chcete přehrávat offline, stáhněte si meditaci pomocí tlačítka \"Stáhnout meditaci\" na této obrazovce.", loadMeditationVC: false)
                }else{
                    // Internet ne, nezakoupena, nestažena.
                    print("SignInVC")
                    loadSignInVC()
                }
            }
        }
    }
    
    @IBOutlet weak var prehrajMeditaciButton: UIButton!
    
    
    @IBAction func stahnoutMeditaciPrssd(_ sender: Any) {
        //  Stažení audio souborů meditace. Pokud je již stažena, slouží k jejich mazání.
        if let downloaded = downloaded, let dostupnost = dostupnost{
            
            if downloaded{
                if !signedIn, !dostupnost{
                    displayMessage(userMessage: "Tuto meditaci musíte nejdříve zakoupit na webu Láskyplného Světa.", loadMeditationVC: false)
                }
                askForPermissionToDelete(userMessage: "Přejete si smazat stažené soubory této meditace?")
            }else if dostupnost{
                meditaceFilesRequest(vcName: "downloadVC")
            }else{
                displayMessage(userMessage: "Tuto meditaci musíte nejdříve zakoupit na webu Láskyplného Světa.", loadMeditationVC: false)
            }
        }
    }
    
    @IBOutlet weak var stahnoutMeditaciBtn: UIButton!
    
    var nadpis: String?
    var obsah: String?
    var obrazekUrl: String?
    var id: Int?
    var dostupnost: Bool?
    var cena: Int?
    var velikost: Int64?
    var downloaded: Bool?
    
    var labelAlreadyUpdated = false
    //  Obsah label je upgradovan o text ve viewwillappear. Diky tomu neni upgradován vícekrát.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prehrajMeditaciButton.layer.cornerRadius = 20
        prehrajMeditaciButton.clipsToBounds = true
        
        if nadpis != nil{
            nadpisMeditaceLabel.text = nadpis
        }
        
        if obrazekUrl != nil{
            if let url = URL(string: obrazekUrl!){
                let resource = ImageResource(downloadURL: url)
                let defaultImage = UIImage(named: "\(id!).jpg")
                velkyImageMeditace.kf.setImage(with: resource, placeholder: defaultImage)
                velkyImageMeditace.layer.cornerRadius = 15
                velkyImageMeditace.clipsToBounds = true
            }
        }
        
        if obsah != nil{
            obsahMeditaceLabel.text = obsah            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        // Nastavení textů buttonů a textu popisu meditace dle stavu meditace: zakoupena, stažena apod.
        if let downloaded = downloaded, let dostupnost = dostupnost{
            
            if downloaded, dostupnost{
                downloadedImage.image = #imageLiteral(resourceName: "downloaded")
            }
            
            if dostupnost{
                
                if downloaded{
                    prehrajMeditaciButton.setTitle("Přehraj offline", for: .normal)
                    stahnoutMeditaciBtn.setTitle("Smazat stáhnutou meditaci.", for: .normal)
                    stahnoutMeditaciBtn.setTitleColor(mojeCervena, for: .normal)
                    if !labelAlreadyUpdated{
                        obsahMeditaceLabel.text = "\(String(describing: obsahMeditaceLabel.text!)) \n \nAudiosoubory této meditace máte staženy v telefonu. Meditaci můžete přehrávat offline."
                        labelAlreadyUpdated = true
                    }
                }else{
                    prehrajMeditaciButton.setTitle("Přehraj online", for: .normal)
                    stahnoutMeditaciBtn.setTitle("Stáhnout meditaci", for: .normal)
                    stahnoutMeditaciBtn.setTitleColor(mojeModra, for: .normal)
                    if !labelAlreadyUpdated{
                        obsahMeditaceLabel.text = "\(String(describing: obsahMeditaceLabel.text!)) \n \nTuto meditaci můžete přehrát online (streamovat) nebo si ji můžete stáhnout do telefonu a poslouchat offline."
                        labelAlreadyUpdated = true
                    }
                }
            }else{
                if signedIn{
                    prehrajMeditaciButton.setTitle("Kup meditaci", for: .normal)
                    if !labelAlreadyUpdated{
                        obsahMeditaceLabel.text = "\(String(describing: obsahMeditaceLabel.text!)) \n \nMeditaci lze zakoupit na webu Láskyplného Světa. Po přihlášení zde v aplikaci pomocí Vašeho emailu a hesla bude možné meditaci zde přehrát. ."
                        labelAlreadyUpdated = true
                    }
                }else{
                    prehrajMeditaciButton.setTitle("Přihlásit", for: .normal)
                    if !labelAlreadyUpdated{
                        obsahMeditaceLabel.text = "\(String(describing: obsahMeditaceLabel.text!)) \n \nPro přehrání meditace je nutné meditaci zakoupit na webu a přihlásit se pod svým uživatelským jménem."
                        labelAlreadyUpdated = true
                    }
                }
            }
        }
        
        
    }
    
    func meditaceFilesRequest(vcName: String){
        // Stáhne informační data jednotlivých meditací
        
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        let url = URL(string: "https://www.ay.energy/api/media/audio")
        let parameters: Parameters = ["id" : id!]
        
        if let tokenUnwrpd = token{
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(String(describing: tokenUnwrpd))",
                "Accept": "application/json"
            ]
        
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300)
                .responseData{ response in
                    let json = JSON(response.data as Any)
                    
                    if vcName == "player"{
                        let newVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vcName) as! MeditacePlayerVC
                        newVC.musicUrl = json["body"]["musicUrl"].string
                        newVC.voiceUrl = json["body"]["voiceUrl"].string
                        newVC.id = self.id!
                        newVC.downloaded = self.downloaded ?? false
                        self.navigationController?.pushViewController(newVC, animated: true)

                    }else if vcName == "downloadVC"{
                        let newVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vcName) as! DownloadVC
                        newVC.musicUrl = json["body"]["musicUrl"].string
                        newVC.voiceUrl = json["body"]["voiceUrl"].string
                        newVC.id = self.id
                        //newVC.view.isOpaque = false
                        newVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        
                        self.navigationController?.present(newVC, animated: true)
                    }
                    print(response.result)
                    }
        }else{
            displayMessage(userMessage: "Ke stažení je zapotřebí internetové připojení.", loadMeditationVC: false)
        }
    }
        
    func displayMessage(userMessage:String, loadMeditationVC: Bool) -> Void {
        // Zobrazí alert se zprávou. Může hned zavolat meditaceVC
        
            DispatchQueue.main.async
                {
                    let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        // Code in this block will trigger when OK button tapped.
                        
                        DispatchQueue.main.async{
                            if loadMeditationVC{
                                let meditaceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meditaceVC") as! MeditaceVC
                                self.navigationController?.pushViewController(meditaceVC, animated: true)
                            }else{
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
            }
        }
    
    func loadSignInVC(){
        let signInVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVc") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
        
    func askForPermissionToDelete(userMessage:String) -> Void {
        // Tento alert se ptá, zda opravdu vymazat meditace
        
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Ano", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    
                    DispatchQueue.main.async{
                        self.dismiss(animated: true, completion: nil)
                        
                        if deleteSoundFiles(id: self.id!){
                            self.downloaded = false
                            self.displayMessage(userMessage: "Soubory meditace byly úspěšně smazány.", loadMeditationVC: true)
                            self.viewDidLoad()
                        }else{
                            self.displayMessage(userMessage: "Nepodařilo se smazat soubory meditace.", loadMeditationVC: false)
                        }
                    }
                }
                
                let noAction = UIAlertAction(title: "Ne", style: .default, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
}

