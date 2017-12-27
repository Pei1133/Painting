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

    static func renderPaths(url: URL, imageView: UIImageView) -> (pictureSize: CGSize, imageView: UIImageView) {

        var pictureSize = CGSize.zero
        let strokeWidth = CGFloat(0.8)
        let strokeColor = UIColor.black.cgColor

        let paths = SVGBezierPath.pathsFromSVG(at: url)
        for path in paths {

            let layer = CAShapeLayer()
            pictureSize = calculatePictureBounds(pictureSize: pictureSize, rect: path.cgPath.boundingBox)
            layer.path = path.cgPath
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            layer.fillColor = UIColor.clear.cgColor
            imageView.layer.addSublayer(layer)
        }

        return (pictureSize: pictureSize, imageView: imageView)
    }

    static func renderCellPaths(url: URL, imageView: UIImageView) -> (pictureSize: CGSize, imageView: UIImageView) {

        var pictureSize = CGSize.zero
        let strokeWidth = CGFloat(0.6)
        let strokeColor = UIColor.darkGray.cgColor

        let paths = SVGBezierPath.pathsFromSVG(at: url)
        for path in paths {

            let layer = CAShapeLayer()
            pictureSize = calculatePictureBounds(pictureSize: pictureSize, rect: path.cgPath.boundingBox)
            let scaleFactor = calculateScaleFactor(pictureSize: pictureSize, imageView: imageView)

            var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let transformedPath = (path.cgPath).copy(using: &affineTransform)
            layer.path = transformedPath

//            layer.path = path.cgPath
//            layer.transform = CATransform3DMakeScale(scaleFactor, scaleFactor, scaleFactor)
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            layer.fillColor = UIColor.white.cgColor
            imageView.layer.addSublayer(layer)

        }
        return (pictureSize: pictureSize, imageView: imageView)
    }

    static func calculatePictureBounds(pictureSize size: CGSize, rect: CGRect) -> CGSize {

        let maxX = rect.maxX
        let maxY = rect.maxY

        let newsizeWidth = size.width > maxX ? size.width : maxX
        let newsizeHeight = size.height > maxY ? size.height : maxY

        return CGSize(width: newsizeWidth, height: newsizeHeight)
    }

    static func calculateScaleFactor(pictureSize: CGSize, imageView: UIImageView) -> CGFloat {

        let boundingBoxAspectRatio = pictureSize.width/pictureSize.height
        let viewAspectRatio = imageView.bounds.width/imageView.bounds.height

        let scaleFactor: CGFloat
        if boundingBoxAspectRatio > viewAspectRatio {
            // Width is limiting factor
            scaleFactor = imageView.bounds.width/pictureSize.width
        } else {
            // Height is limiting factor
            scaleFactor = imageView.bounds.height/pictureSize.height
        }

        return scaleFactor
    }

}
