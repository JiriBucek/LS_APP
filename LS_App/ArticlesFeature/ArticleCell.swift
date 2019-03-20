//
//  ArticleCellTableViewCell.swift
//  LS_App
//
//  Created by Boocha on 24.07.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    // Buňka článku v tableview.
    
    @IBOutlet weak var nadpisLabel: UILabel!
    
    @IBOutlet weak var popisekLabel: UILabel!
    
    @IBOutlet weak var obrazekView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
