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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
    var meditaceData = ["nadpis":"Meditace osobní prostor", "popisek":"Meditace v bílém prostoru, v osobním prostoru a všude možně", "obrazekName": "meditace_default.jpg", "obsah":"Zde bude vypsán obsah popisu meditace. Jelikož ještě žádnej nemám, tak sem píšu tento nesmysl, aby tu alespoň něco bylo a já viděl, jak to bude nakonec vypadat. Potřebuju ještě alespoň pár vět, aby to napodobilo vzdáleně realitu. Raz dva raz dva. Už to skoro bude. Takhle by to mohlo stačit.", "audiosoubor":"meditace_1.mp3"]

    
}
