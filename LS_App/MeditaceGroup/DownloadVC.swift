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
    
    @IBAction func prerusitBtnPressed(_ sender: Any) {
    }
    
    var voiceUrl: String?
    var musicUrl: String?
    var id: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        
        
        Alamofire.download(musicUrl!, to: hudbaDestination)
            .downloadProgress{progress in
                print("Progress: ", progress.fractionCompleted)
                self.hudbaProgressView.progress = Float(progress.fractionCompleted)
            }
            
            .response{ response in
                
                Alamofire.download(self.voiceUrl!, to: slovoDestination)
                    .downloadProgress{progress in
                        self.slovoProgressView.progress = Float(progress.fractionCompleted)
                }
                
            
        }
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
