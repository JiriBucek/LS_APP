//
//  mujSlider.swift
//  LS_App
//
//  Created by Boocha on 24.10.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

class LSSlider: UISlider {
    // Custom slider pro přehrávač meditací. 
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let vlastniBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 4.0))
        super.trackRect(forBounds: vlastniBounds)
        return vlastniBounds
    }
}
