//
//  MeditaceVC.swift
//  LS_App
//
//  Created by Boocha on 17.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import Foundation

class MeditaceVC: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var meditaceArray:[MeditaceClass]? = []
    
    @IBOutlet weak var meditaceTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadMeditationData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadMeditationData(){
        
        for item in meditaceData{
            
            let meditaceObjekt = MeditaceClass()
            
            meditaceObjekt.nadpis = item["nadpis"]!
            meditaceObjekt.obsah = item["obsah"]
            meditaceObjekt.obrazekName = item["obrazekName"]
            meditaceObjekt.audioSlovo = item["audio_slovo"]
            meditaceObjekt.audioHudba = item["audio_hudba"]
            
            meditaceArray?.append(meditaceObjekt)
        }
        
        meditaceTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meditaceTableView.dequeueReusableCell(withIdentifier: "meditaceCell", for: indexPath) as! MeditaceCell
        
        cell.nadpisCellMeditace.text = self.meditaceArray?[indexPath.item].nadpis
        cell.popisekCellMeditace.text = self.meditaceArray?[indexPath.item].obsah
        let jmenoObrazku = self.meditaceArray?[indexPath.item].obrazekName
        
        cell.obrazekMalyMeditace.image = UIImage(imageLiteralResourceName: jmenoObrazku!)
        
        cell.obrazekMalyMeditace.layer.cornerRadius = 5
        cell.obrazekMalyMeditace.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let detailMeditaceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meditaceDetail") as! DetailMeditaceVC
        
        detailMeditaceVC.nadpis = self.meditaceArray?[indexPath.item].nadpis
        detailMeditaceVC.obsah =  self.meditaceArray?[indexPath.item].obsah
        detailMeditaceVC.image = self.meditaceArray?[indexPath.item].obrazekName
        detailMeditaceVC.mluveneSlovo = self.meditaceArray?[indexPath.item].audioSlovo
        detailMeditaceVC.podkladovaHudba = self.meditaceArray?[indexPath.item].audioHudba
        detailMeditaceVC.title = self.meditaceArray?[indexPath.item].nadpis
        
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
    var meditaceData = [
        
        ["nadpis" : "1. osobní prostor", "obrazekName": "1_meditace.jpg", "obsah" : "Jdi hlouběji a hlouběji do sebe, poznej své niterné sféry, projdi dále a převezmi sílu pro tvoření Tvého světa. Uchovej si svůj vlastní osobní prostor a kráčej tak životem sebe-vědomě a sebe-jistě. Ty jsi tvůrcem svého života.", "audio_slovo":"1_slovo_niterne_poznani", "audio_hudba":"1_hudba"],
        
        ["nadpis":"2. Síla koncentrace", "obrazekName": "2_meditace.jpg", "obsah":"V dnešním světě dosahuje lepších úspěchů ten, kdo se dokáže pevněji a vytrvaleji soustředit na svůj cíl. Na tu jednu nehmatatelnou myšlenku, kterou chce tvořit. V této nahrávce budeme zesilovat svou schopnost silné koncentrace, to se zákonitě bude odrážet v efektivitě práce a úspěšnějším životě.", "audio_slovo":"2_slovo_pozorovani_jedne_myslenky", "audio_hudba":"1_hudba"]
        
    ]

    
}
