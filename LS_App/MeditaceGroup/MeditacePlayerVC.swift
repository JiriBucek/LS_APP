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
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var hudbaBtn: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        animateButton(sender: sender)
        
        
        if playerSlovo == nil{
            playSlovo(time: 0)
            playBtn.setImage(#imageLiteral(resourceName: "pause.png"), for: .normal)
           // progressLabel.text = "\(secondsToMinutesSeconds(seconds: momentalniPozice!)) : \(secondsToMinutesSeconds(seconds: delkaNahravky!))"

            
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
    
    
    var mluveneSlovo: String?
    var podkladovaHudba: String?
    
    var playerSlovo: AVAudioPlayer?
    var playerHudba: AVAudioPlayer?
    
    var delkaNahravky: Int?
    var momentalniPozice: Int?
    
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if playerSlovo != nil{
            progressLabel.text = "\(sekundyParser(seconds: momentalniPozice!)) : \(sekundyParser(seconds: delkaNahravky!))"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
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

            
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
            
            player.currentTime = time
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func timerFunc(){
            delkaNahravky = Int((playerSlovo?.duration)!)
            momentalniPozice = Int((playerSlovo?.currentTime)!)
        
            let progres = Float(momentalniPozice!)/Float(delkaNahravky!)
        
            progressBar.progress = progres
        
        progressLabel.text = "\(sekundyParser(seconds: momentalniPozice!)) / \(sekundyParser(seconds: delkaNahravky!))"
        
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
