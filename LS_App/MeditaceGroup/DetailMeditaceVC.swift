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

    @IBOutlet weak var velkyImageMeditace: UIImageView!
    
    @IBOutlet weak var nadpisMeditaceLabel: UILabel!
    
    @IBOutlet weak var obsahMeditaceLabel: UILabel!
    
    @IBAction func prehrajMeditaciPressed(_ sender: Any) {

        if checkInternet(){
            if dostupnost!{
                let backItem = UIBarButtonItem()
                backItem.title = "Zpět"
                navigationItem.backBarButtonItem = backItem
                meditaceFilesRequest(vcName: "player")
               
            }else{
                let url = URL(string: "http://www.laskyplnysvet.cz/audiomeditace")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }
        }else{
            if downloaded!{
                let newVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "player") as! MeditacePlayerVC
                newVC.id = self.id!
                newVC.downloaded = self.downloaded ?? false
                self.navigationController?.pushViewController(newVC, animated: true)
            }else{
                displayMessage(userMessage: "K přehrávání meditací online je zapotřebí připojení k internetu. Pokud chcete přehrávat offline, stáhněte si meditaci pomocí tlačítka \"Stáhnout meditaci\" na této obrazovce.", loadMeditationVC: false)
        }
        }
    }
    
    @IBOutlet weak var prehrajMeditaciButton: UIButton!
    
    
    @IBAction func stahnoutMeditaciPrssd(_ sender: Any) {
        
        if let downloadedUnwrapped = downloaded{
            if downloadedUnwrapped{
                if deleteSoundFiles(id: id!){
                    self.downloaded = false
                    displayMessage(userMessage: "Soubory meditace byly úspěšně smazány.", loadMeditationVC: true)
                    self.viewDidLoad()
                }else{
                    displayMessage(userMessage: "Nepodařilo se smazat soubory meditace.", loadMeditationVC: false)
                }
            }else{
            meditaceFilesRequest(vcName: "downloadVC")
            print("stahnout btn pressed")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let downloadedUnwrapped = downloaded{
            if downloadedUnwrapped{
                stahnoutMeditaciBtn.setTitle("Smazat stáhnutou meditaci.", for: .normal)
                stahnoutMeditaciBtn.setTitleColor(.red, for: .normal)
                
            }else{
                stahnoutMeditaciBtn.setTitle("Stáhnout meditaci", for: .normal)
                stahnoutMeditaciBtn.setTitleColor(.blue, for: .normal)
            }
        }
        
        prehrajMeditaciButton.layer.cornerRadius = 20
        prehrajMeditaciButton.clipsToBounds = true

        if dostupnost!{
            prehrajMeditaciButton.setTitle("Přehraj meditaci", for: .normal)
        }else{
            prehrajMeditaciButton.setTitle("Kup meditaci", for: .normal)
        }
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func meditaceFilesRequest(vcName: String){
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        let url = URL(string: "https://www.ay.energy/api/media/audio")
        let parameters: Parameters = ["id" : id!]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(String(describing: token!))",
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
    }
        
    func displayMessage(userMessage:String, loadMeditationVC: Bool) -> Void {
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
        
    
    

}

/*
    func playHudba() -> Void {
    //přehrává hudbu
        
        let url = Bundle.main.url(forResource: podkladovaHudba, withExtension: "mp3")!
        do {
            playerHudba = try AVAudioPlayer(contentsOf: url)
            guard let playerHudba = playerHudba else { return }
            playerHudba.numberOfLoops = -1
            //nekonečně přehrávání
            playerHudba.prepareToPlay()
            playerHudba.play()
    } catch let error {
    print(error.localizedDescription)
    }
    }
    
    
    
    func playSlovo(time: TimeInterval) -> Void {
        //přehrává zvuky
        if playerSlovo != nil{
            playerSlovo?.pause()
        }
        
        let url = Bundle.main.url(forResource: mluveneSlovo, withExtension: "mp3")!
        do {
            playerSlovo = try AVAudioPlayer(contentsOf: url)
            guard let player = playerSlovo else { return }
           
            player.prepareToPlay()
            player.currentTime = time
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func skipSlovo(oKolik: Double){
        if playerSlovo != nil{
            var pozice = (playerSlovo?.currentTime)! + oKolik
            if pozice < 0{
                pozice = 0
            }
            
            if pozice < (playerSlovo?.duration)!{
                print(pozice)
                playerSlovo?.currentTime = pozice
            }else{
                playerSlovo?.stop()
            }
        }
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
*/
