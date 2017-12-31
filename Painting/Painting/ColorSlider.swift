//
//  ColorSlider.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/31.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit

class ColorSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect: CGRect = CGRectMake(0, 0, 100, 30)
        return rect
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
