//
//  PathProvider.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/21.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG

class PathProvider {

    static func renderPaths(url: URL, imageView: UIImageView) -> UIImageView {

        var pictureSize = CGSize.zero
        let strokeWidth = CGFloat(1.0)
        let strokeColor = UIColor.black.cgColor

        let paths = SVGBezierPath.pathsFromSVG(at: url)
        for path in paths {

            let layer = CAShapeLayer()
            pictureSize = calculatePictureBounds(pictureSize: pictureSize, rect: path.cgPath.boundingBox)
            layer.path = path.cgPath
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            layer.fillColor = UIColor.white.cgColor

            imageView.frame = CGRect(x: 0, y: 0, width: pictureSize.width, height: pictureSize.height)
            imageView.layer.addSublayer(layer)

        }
        return imageView
    }

    static func calculatePictureBounds(pictureSize size: CGSize, rect: CGRect) -> CGSize {

        let maxX = rect.maxX
        let maxY = rect.maxY

        let newsizeWidth = size.width > maxX ? size.width : maxX
        let newsizeHeight = size.height > maxY ? size.height : maxY

        return CGSize(width: newsizeWidth, height: newsizeHeight)

        }
}
