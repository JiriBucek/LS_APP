//
//  DownloadVC.swift
//  LS_App
//
//  Created by Boocha on 15.02.19.
//  Copyright © 2019 Boocha. All rights reserved.
//

import UIKit
import Alamofire

class DownloadVC: UIViewController {
    
    
    @IBOutlet weak var hudbaLabel: UILabel!
    
    @IBOutlet weak var hudbaProgressView: UIProgressView!
    
    @IBOutlet weak var slovoLabel: UILabel!
    
    @IBOutlet weak var slovoProgressView: UIProgressView!
    
    @IBOutlet weak var greyDownloadView: UIView!
    
    @IBOutlet weak var zrusitBtn: UIButton!
    
    @IBAction func prerusitBtnPressed(_ sender: Any) {
        cancelAllAlamofireRequests()
        stahovatSlovo = false
        self.dismiss(animated: true, completion: nil)
    }
    var voiceUrl: String?
    var musicUrl: String?
    var id: Int?
    var stahovatSlovo = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greyDownloadView.layer.cornerRadius = 20
        greyDownloadView.clipsToBounds = true
        zrusitBtn.layer.cornerRadius = zrusitBtn.frame.height/2
        zrusitBtn.clipsToBounds = true
        
        if !checkInternet(){
            displayMessage(userMessage: "Pro stahování meditací je zapotřebí připojení k internetu.")
        }
        
        
        let hudbaDestination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(self.id!)_hudba.mp3")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let slovoDestination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(self.id!)_slovo.mp3")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if let musicURLunwrapped = musicUrl{
        
            Alamofire.download(musicURLunwrapped, to: hudbaDestination)
                //stahování hudby, po dokončení se stahuje slovo
                .downloadProgress{progress in
 
                    let stazeno = Double(progress.completedUnitCount/100000)/10
                    let celkovaVelikost = Double(progress.totalUnitCount/100000)/10
                    
                    self.hudbaLabel.text = "Hudba: \(stazeno) MB / \(celkovaVelikost) MB"
                    self.hudbaProgressView.progress = Float(progress.fractionCompleted)
                }
                
                .response{ response in
                    if self.stahovatSlovo{
                    //pokud přeruším stahování u prvního souboru, nechci, aby se začal stahovat tento
            
                        Alamofire.download(self.voiceUrl!, to: slovoDestination)
                            //stahování slova
                            .downloadProgress{progress in
                                let stazeno = Double(progress.completedUnitCount/100000)/10
                                let celkovaVelikost = Double(progress.totalUnitCount/100000)/10
                                
                                self.slovoLabel.text = "Mluvené slovo: \(stazeno) MB / \(celkovaVelikost) MB"
                                self.slovoProgressView.progress = Float(progress.fractionCompleted)
                            }
                            .response{response in
                                //po dokončení stahování slova se načte seznam meditací
                                self.dismiss(animated: true, completion: nil)
        
                                let rootVC = self.presentingViewController as! UINavigationController!
                                let meditaceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meditaceVC") as! MeditaceVC
                                rootVC?.pushViewController(meditaceVC, animated: true)
                                
                        }
                    }
                }
            
        }
    }
    
    
    
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
                
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
