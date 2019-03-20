//
//  LoadingCell.swift
//  InfiniteScrollingExample
//
//  Created by Robert Canton on 2018-03-13.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    //  Malý spinner pro načítání nových článků na konci tableview

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
