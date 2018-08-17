//
//  DetailMeditaceVC.swift
//  LS_App
//
//  Created by Boocha on 18.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import AVFoundation

class DetailMeditaceVC: UIViewController {

    @IBOutlet weak var velkyImageMeditace: UIImageView!
    
    @IBOutlet weak var nadpisMeditaceLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        skipAudio()
    }
    
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        if player == nil || player?.isPlaying == false {
            playSound(file: "overwerk", ext: "mp3", time: 0.0)
        }else{
            player?.stop()
        }
        
    }
    
    var nadpis: String?
    var popisek: String?
    var image: String?
    
    var player: AVAudioPlayer?
    //přehrává audio
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if nadpisMeditaceLabel != nil{
            nadpisMeditaceLabel.text = nadpis
        }
        
        if velkyImageMeditace != nil{
            velkyImageMeditace.image = UIImage(imageLiteralResourceName: image!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSound(file:String, ext:String, time: Double) -> Void {
        //přehrává zvuky
        let url = Bundle.main.url(forResource: file, withExtension: ext)!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
           
            player.prepareToPlay()
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func skipAudio(){
        let pozice = player?.currentTime
        print(pozice)
        player?.stop()
        playSound(file: "overwerk", ext: "mp3", time: pozice! + 15.0)
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
