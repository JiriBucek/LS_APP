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
    
    
    //dvojka je spodní
    @IBOutlet weak var slider: mujSlider!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func sliderMoved(_ sender: Any) {
        let sliderValue = slider.value
        let posunNaCas = sliderValue * Float(delkaNahravky)
        print(posunNaCas)
        
        playerSlovo?.currentItem?.seek(to: CMTime(seconds: Double(posunNaCas), preferredTimescale: 1), completionHandler: nil)
    }
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var hudbaBtn: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        animateButton(sender: sender)
        
        if playerSlovo == nil{
            playSlovo(time: 0)
            playBtn.setImage(#imageLiteral(resourceName: "pause.png"), for: .normal)
        }else if (playerSlovo?.isPlaying)!{
            playerSlovo?.pause()
            playBtn.setImage(#imageLiteral(resourceName: "play.png"), for: .normal)
        }else{
            playerSlovo?.play()
            playBtn.setImage(#imageLiteral(resourceName: "pause.png"), for: .normal)
        }
        if playerHudba == nil{
            playHudba()
        }
    }
    
    @IBAction func hudbaBtnPressed(_ sender: UIButton) {
        animateButton(sender: sender)
        
        if playerHudba == nil{
            playHudba()
        }else if (playerHudba?.isPlaying)!{
            playerHudba?.pause()
            hudbaBtn.setImage(#imageLiteral(resourceName: "nosound.png"), for: .normal)
        }else{
            playerHudba?.play()
            hudbaBtn.setImage(#imageLiteral(resourceName: "sound.png"), for: .normal    )
        }
    }
    
    @IBAction func vpredBtnPressed(_ sender: UIButton) {
        animateButton(sender: sender)
        skipSlovo(oKolik: 15)
    }
    
    @IBAction func vzadBtnPressed(_ sender: UIButton) {
        animateButton(sender: sender)
        skipSlovo(oKolik: -15)
    }
    var voiceUrl: String?
    var musicUrl: String?
    var isDownloadable: Bool?
    var mluveneSlovo: String?
    var podkladovaHudba: String?
    var playerSlovo: AVPlayer?
    var playerHudba: AVPlayer?
    var delkaNahravky: Double = 0
    var momentalniPozice: Double = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        UIApplication.shared.isIdleTimerDisabled = true
        //obrazovka se nevypne
        
        super.viewDidLoad()
        
        playSlovo(time: 0)
        playerSlovo?.pause()
        
        if playerSlovo != nil{
            progressLabel.text = "\(sekundyParser(seconds: Int(momentalniPozice))) : \(sekundyParser(seconds: Int(delkaNahravky)))"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //po ukončení vypnu timer a obrazovka se zase vypíná
        if self.isMovingFromParentViewController{
            //zmacknul jsem back button?
            playerSlovo?.pause()
            playerHudba?.pause()
            timer?.invalidate()
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    func playHudba() -> Void {
        //přehrává hudbu
        //let url = Bundle.main.url(forResource: podkladovaHudba, withExtension: "mp3")!
        let url = URL(string: musicUrl!)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        
        playerHudba = AVPlayer(playerItem: playerItem)
        //playerHudba.numberOfLoops = -1
        //nekonečně přehrávání
        //playerHudba.prepareToPlay()
        playerHudba?.play()
    }
    
    func playSlovo(time: TimeInterval) -> Void {
        //přehrává zvuky
        if playerSlovo != nil{
            playerSlovo?.pause()
        }
        //let url = Bundle.main.url(forResource: mluveneSlovo, withExtension: "mp3")!
        let url = URL(string: voiceUrl!)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
            playerSlovo = AVPlayer(playerItem: playerItem)
            //player.prepareToPlay()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
            //playerSlovo!.setRate(1, time: CMTime(seconds: time, preferredTimescale: 1), atHostTime: CMTime(seconds: time, preferredTimescale: 1))
        playerSlovo!.play()
    }
    
    @objc func timerFunc(){
        delkaNahravky = Double((playerSlovo?.currentItem?.duration.seconds)!)
        momentalniPozice = Double((playerSlovo?.currentItem?.currentTime().seconds)!)
        
        if delkaNahravky.isNaN{
            delkaNahravky = 0
        }
        let progres = Float(momentalniPozice)/Float(delkaNahravky)
        
        slider.value = progres
        
        progressLabel.text = "\(sekundyParser(seconds: Int(momentalniPozice))) / \(sekundyParser(seconds: Int(delkaNahravky)))"
    }
    
    func skipSlovo(oKolik: Double){
        //posouvá mluvené slovo vpřed nebo vzad
        if playerSlovo != nil{
            var pozice = (playerSlovo?.currentItem?.currentTime().seconds)! + oKolik
            if pozice < 0{
                pozice = 0
            }
            
            if pozice < (playerSlovo?.currentItem?.duration.seconds)!{
                print("Posun na pozici. ", pozice)
                playerSlovo?.seek(to: CMTime(seconds: pozice, preferredTimescale: 1))
            }else{
                playerSlovo?.pause()
            }
        }
    }
    
    func animateButton(sender: UIButton){
        //animace tlačítka při zmáčknutí
        UIButton.animate(withDuration: 0.2,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }
    
    func sekundyParser(seconds : Int) -> String {
        let minuty = "\((seconds % 3600) / 60)"
        var sekundy = "\((seconds % 3600) % 60)"
        
        if sekundy.count == 1{
            sekundy = "0" + sekundy
        }
        
        return "\(minuty):\(sekundy)"
    }
}

extension AVPlayer {
    //udává, zda player hraje či ne
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
}
