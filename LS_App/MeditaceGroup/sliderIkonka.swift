//
//  sliderIkonka.swift
//  LS_App
//
//  Created by Boocha on 25.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

@IBDesignable
class sliderIkonka: UISlider {
    @IBInspectable var thumbImage: UIImage?{
        didSet{
            setThumbImage(thumbImage, for: .normal)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
