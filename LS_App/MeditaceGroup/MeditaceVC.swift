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
            meditaceObjekt.popisek = item["popisek"]!
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
        cell.popisekCellMeditace.text = self.meditaceArray?[indexPath.item].popisek
        let jmenoObrazku = self.meditaceArray?[indexPath.item].obrazekName
        
        cell.obrazekMalyMeditace.image = UIImage(imageLiteralResourceName: jmenoObrazku!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let detailMeditaceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meditaceDetail") as! DetailMeditaceVC
        
        detailMeditaceVC.nadpis = self.meditaceArray?[indexPath.item].nadpis
        detailMeditaceVC.image = self.meditaceArray?[indexPath.item].obrazekName
        detailMeditaceVC.mluveneSlovo = self.meditaceArray?[indexPath.item].audioSlovo
        detailMeditaceVC.podkladovaHudba = self.meditaceArray?[indexPath.item].audioHudba
        
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
        
        ["nadpis":"Meditace osobní prostor", "popisek":"Meditace v bílém prostoru, v osobním prostoru a všude možně", "obrazekName": "meditace_default.jpg", "obsah":"Zde bude vypsán obsah popisu meditace. Jelikož ještě žádnej nemám, tak sem píšu tento nesmysl, aby tu alespoň něco bylo a já viděl, jak to bude nakonec vypadat. Potřebuju ještě alespoň pár vět, aby to napodobilo vzdáleně realitu. Raz dva raz dva. Už to skoro bude. Takhle by to mohlo stačit.", "audio_slovo":"1_slovo_niterne_poznani", "audio_hudba":"1_hudba"],
        
        ["nadpis":"Meditace prostor 2", "popisek":"Meditace v bílém prostoru, v osobním prostoru a všude možně", "obrazekName": "Ra.jpg", "obsah":"Zde bude vypsán obsah popisu meditace. Jelikož ještě žádnej nemám, tak sem píšu tento nesmysl, aby tu alespoň něco bylo a já viděl, jak to bude nakonec vypadat. Potřebuju ještě alespoň pár vět, aby to napodobilo vzdáleně realitu. Raz dva raz dva. Už to skoro bude. Takhle by to mohlo stačit.", "audio_slovo":"1_slovo_niterne_poznani", "audio_hudba":"1_hudba"]
        
    ]

    
}
