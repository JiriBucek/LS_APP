//
//  MeditaceVC.swift
//  LS_App
//
//  Created by Boocha on 17.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit
import Foundation
import SwiftyUserDefaults

class MeditaceVC: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var meditaceArray:[MeditaceClass]? = []
    
    @IBAction func refreshBtn(_ sender: Any) {
        Defaults.removeAll()
        meditaceTableView.reloadData()
        
    }
    
    
    @IBOutlet weak var meditaceTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadMeditationData()
        print("Not first launch: ", Defaults[.notFirstLaunch])

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.isNavigationBarHidden = true
        
        if !Defaults[.notFirstLaunch]!{
            // co se stane při prvním spuštění
            Defaults[.notFirstLaunch] = true
            Defaults[.meditace1] = true
            Defaults[.meditace2] = false
            Defaults[.meditace3] = true
            Defaults[.meditace4] = false
            Defaults[.meditace5] = true
        }
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadMeditationData(){
        
        for item in meditaceData{
            
            let meditaceObjekt = MeditaceClass()
            
            meditaceObjekt.id = item["id"]
            meditaceObjekt.nadpis = item["nadpis"]
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
        let meditaceId = self.meditaceArray?[indexPath.item].id
        
        print(Defaults.bool(forKey: meditaceId!))
        
        if (Defaults.bool(forKey: meditaceId!) == true){
            cell.obrazekMalyMeditace.image = UIImage(imageLiteralResourceName: jmenoObrazku!)
        }else{
            cell.obrazekMalyMeditace.image = #imageLiteral(resourceName: "locked.png")
        }
        
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
        detailMeditaceVC.id = self.meditaceArray?[indexPath.item].id
        
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
        
        ["id" : "meditace1", "nadpis" : "1. osobní prostor", "obrazekName": "1_meditace.jpg", "obsah" : "Jdi hlouběji a hlouběji do sebe, poznej své niterné sféry, projdi dále a převezmi sílu pro tvoření Tvého světa. Uchovej si svůj vlastní osobní prostor a kráčej tak životem sebe-vědomě a sebe-jistě. Ty jsi tvůrcem svého života.", "audio_slovo":"1_slovo_niterne_poznani", "audio_hudba":"1_hudba"],
        
        ["id" : "meditace2", "nadpis":"2. Síla koncentrace", "obrazekName": "2_meditace.jpg", "obsah":"V dnešním světě dosahuje lepších úspěchů ten, kdo se dokáže pevněji a vytrvaleji soustředit na svůj cíl. Na tu jednu nehmatatelnou myšlenku, kterou chce tvořit. V této nahrávce budeme zesilovat svou schopnost silné koncentrace, to se zákonitě bude odrážet v efektivitě práce a úspěšnějším životě.", "audio_slovo":"2_slovo_pozorovani_jedne_myslenky", "audio_hudba":"1_hudba"],
        
        ["id" : "meditace3", "nadpis":"3. Rozloučení s depresí", "obrazekName": "3_meditace.jpg", "obsah":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut tempus purus at lorem. Integer tempor. Maecenas fermentum, sem in pharetra pellentesque, velit turpis volutpat ante, in pharetra metus odio a lectus. Duis bibendum, lectus ut viverra rhoncus, dolor nunc faucibus libero, eget facilisis enim ipsum id lacus. Integer lacinia. Etiam ligula pede, sagittis quis, interdum ultricies, scelerisque eu. Fusce dui leo, imperdiet in, aliquam sit amet, feugiat eu, orci. Praesent vitae arcu tempor neque lacinia pretium. Integer tempor.", "audio_slovo":"3_rozlouceni_s_depresi", "audio_hudba":"3_hudba"],
        
         ["id" : "meditace4", "nadpis":"4. Meditace dobré ráno", "obrazekName": "4_meditace.jpg", "obsah":"Phasellus enim erat, vestibulum vel, aliquam a, posuere eu, velit. Fusce aliquam vestibulum ipsum. Curabitur sagittis hendrerit ante. Fusce nibh. Integer lacinia. Phasellus enim erat, vestibulum vel, aliquam a, posuere eu, velit. Cras pede libero, dapibus nec, pretium sit amet, tempor quis. In rutrum. Fusce aliquam vestibulum ipsum. Pellentesque sapien. Sed ac dolor sit amet purus malesuada congue. In convallis. Morbi scelerisque luctus velit. Pellentesque sapien.", "audio_slovo":"2_slovo_pozorovani_jedne_myslenky", "audio_hudba":"1_hudba"],
     
         ["id" : "meditace5", "nadpis":"5. Pátá meditace", "obrazekName": "5_meditace.jpeg", "obsah":"Phasellus enim erat, vestibulum vel, aliquam a, posuere eu, velit. Fusce aliquam vestibulum ipsum. Curabitur sagittis hendrerit ante. Fusce nibh. Integer lacinia. Phasellus enim erat, vestibulum vel, aliquam a, posuere eu, velit. Cras pede libero, dapibus nec, pretium sit amet, tempor quis. In rutrum. Fusce aliquam vestibulum ipsum. Pellentesque sapien. Sed ac dolor sit amet purus malesuada congue. In convallis. Morbi scelerisque luctus velit. Pellentesque sapien.", "audio_slovo":"2_slovo_pozorovani_jedne_myslenky", "audio_hudba":"1_hudba"]
        
    ]

    
}

extension DefaultsKeys {
    // NSUserDefaults keys pro SwiftyUserDefaults
    // https://cocoapods.org/pods/SwiftyUserDefaults
    
    static let notFirstLaunch = DefaultsKey<Bool?>("notFirstLaunch")

    static let meditace1 = DefaultsKey<Bool?>("meditace1")
    static let meditace2 = DefaultsKey<Bool?>("meditace2")
    static let meditace3 = DefaultsKey<Bool?>("meditace3")
    static let meditace4 = DefaultsKey<Bool?>("meditace4")
    static let meditace5 = DefaultsKey<Bool?>("meditace5")
    
    
}
