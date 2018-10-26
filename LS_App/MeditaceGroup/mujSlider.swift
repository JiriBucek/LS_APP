//
//  mujSlider.swift
//  LS_App
//
//  Created by Boocha on 24.10.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

class mujSlider: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 4.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    /*
    override func awakeFromNib() {
        self.setThumbImage(UIImage(named: "customThumb"), for: .normal)
        super.awakeFromNib()
    }
    */
}
