//
//  MeditacePlayerVC.swift
//  LS_App
//
//  Created by Boocha on 19.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import AVFoundation

class MeditacePlayerVC: UIViewController {
    
    
    @IBAction func playBtnPressed(_ sender: Any) {
        if playerSlovo == nil{
            playSlovo(time: 0)
        }else if (playerSlovo?.isPlaying)!{
            playerSlovo?.pause()
        }else{
            playerSlovo?.play()
        }
        
        if playerHudba == nil{
            playHudba()
        }
    }
    
    @IBAction func hudbaBtnPressed(_ sender: Any) {
        if playerHudba == nil{
            playHudba()
        }else if (playerHudba?.isPlaying)!{
            playerHudba?.pause()
        }else{
            playerHudba?.play()
        }
    }
    
    @IBAction func vpredBtnPressed(_ sender: Any) {
        skipSlovo(oKolik: 15)
    }
    
    @IBAction func vzadBtnPressed(_ sender: Any) {
        skipSlovo(oKolik: -15)
    }
    
    
    var mluveneSlovo: String?
    var podkladovaHudba: String?
    
    var playerSlovo: AVAudioPlayer?
    var playerHudba: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
        //posouvá mluvené slovo vpřed nebo vzad
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
    
    
    


}
