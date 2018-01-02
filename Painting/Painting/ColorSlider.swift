//
//  ColorSlider.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/31.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit

class ColorSlider: UISlider {

//    var currentSelectionX: CGFloat = 0

    override func trackRect(forBounds bounds: CGRect) -> CGRect {

        let rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 13)
        return rect
    }

//    override func draw(_ rect: CGRect) {
//        UIColor.black.set()
//        var tempYPlace = self.currentSelectionX
//        if tempYPlace < CGFloat (0.0) {
//            tempYPlace = CGFloat (0.0)
//        }else if tempYPlace >= self.frame.size.width {
//            tempYPlace = self.frame.size.width - 1.0
//        }
//        let temp = CGRect(x: 0.0, y: tempYPlace, width: 1.0, height: self.frame.size.height)
//        UIRectFill(temp)
//
//        //draw central bar over it
//        let width = Int(self.frame.size.width)
//        for i in 0 ..< width {
//            UIColor(hue: 1.0, saturation: 1.0, brightness: CGFloat (i)/self.frame.size.width, alpha: 1.0).set()
//            let temp = CGRect(x: CGFloat(i), y: 0, width: 1.0, height: self.frame.size.height)
//            UIRectFill(temp)
//        }
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
