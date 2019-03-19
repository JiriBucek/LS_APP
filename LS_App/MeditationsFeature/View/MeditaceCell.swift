//
//  MeditaceCell.swift
//  LS_App
//
//  Created by Boocha on 17.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

class MeditaceCell: UITableViewCell {
    // TableView buňka pro meditační featuru aplikace
    
    @IBOutlet weak var nadpisCellMeditace: UILabel!
    
    @IBOutlet weak var obrazekMalyMeditace: UIImageView!
    
    @IBOutlet weak var popisekCellMeditace: UILabel!
    
    @IBOutlet weak var vrchniObrazek: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
