//
//  MeditaceCell.swift
//  LS_App
//
//  Created by Boocha on 17.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

class MeditaceCell: UITableViewCell {

    
    @IBOutlet weak var nadpisCellMeditace: UILabel!
    
    @IBOutlet weak var obrazekMalyMeditace: UIImageView!
    
    @IBOutlet weak var popisekCellMeditace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
