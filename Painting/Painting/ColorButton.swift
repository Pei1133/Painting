//
//  ColorButton.swift
//  Painting
//
//  Created by 黃珮鈞 on 2018/1/14.
//  Copyright © 2018年 黃珮鈞. All rights reserved.
//

import UIKit

class ColorButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.layer.cornerRadius = self.frame.height*0.5
        self.layer.shadowColor = Colors.coolGray.cgColor
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 1.0
    }

}
