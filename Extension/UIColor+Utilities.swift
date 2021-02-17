//
//  UIColor+Utilities.swift
//  Painting
//
//  Created by 黃珮鈞 on 2018/1/1.
//  Copyright © 2018年 黃珮鈞. All rights reserved.
//

import UIKit
public extension UIColor {
    public var hexCode: String {
        get {
            let colorComponents = self.cgColor.components
            return String(format: "%02x%02x%02x", Int(colorComponents![0]*255.0), Int(colorComponents![1]*255.0), Int(colorComponents![2]*255.0)).uppercased()
        }
    }

    //Amount should be between 0 and 1
    public func lighterColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: UIColor.white, amount: amount)
    }

    public func darkerColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: UIColor.black, amount: amount)
    }

    public static func blendColors(color: UIColor, destinationColor: UIColor, amount: CGFloat) -> UIColor {
        var amountToBlend = amount
        if amountToBlend > 1 {
            amountToBlend = 1.0
        }
        else if amountToBlend < 0 {
            amountToBlend = 0
        }

        var blendR, blendG, blendB, blendAlpha: CGFloat
        blendR = 0
        blendG = 0
        blendB = 0
        blendAlpha = 0
        color.getRed(&blendR, green: &blendG, blue: &blendB, alpha: &blendAlpha) //gets the rgba values (0-1)

        //Get the destination rgba values
        var destR, destG, destB, destAlpha: CGFloat
        destR = 0
        destG = 0
        destB = 0
        destAlpha = 0
        destinationColor.getRed(&destR, green: &destG, blue: &destB, alpha: &destAlpha)

        blendR = amountToBlend * (destR * 255) + (1 - amountToBlend) * (blendR * 255)
        blendG = amountToBlend * (destG * 255) + (1 - amountToBlend) * (blendG * 255)
        blendB = amountToBlend * (destB * 255) + (1 - amountToBlend) * (blendB * 255)
        blendAlpha = fabs(blendAlpha / destAlpha)

        return UIColor(red: blendR/255.0, green: blendG/255.0, blue: blendB/255.0, alpha: blendAlpha)
    }

}
