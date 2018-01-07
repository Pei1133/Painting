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

    func renderPaths(url: URL, imageView: CustomImageView) -> (pictureSize: CGSize, imageView: CustomImageView) {

        var pictureSize = CGSize.zero
        let strokeWidth = CGFloat(2.0)
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

    func renderCellPaths(
        url: URL,
        targetSize: CGSize,
        completionHandler: @escaping (_ pathLayers: [CALayer] ) -> Void
    ) {

        var pictureSize = CGSize.zero
        let strokeWidth = CGFloat(0.6)
        let strokeColor = UIColor.darkGray.cgColor

        DispatchQueue.global().async {

            let paths = SVGBezierPath.pathsFromSVG(at: url)

            var pathLayers = [CALayer]()

            for path in paths {

                let layer = CAShapeLayer()

                pictureSize = self.calculatePictureBounds(pictureSize: pictureSize, rect: path.cgPath.boundingBox)
                let scaleFactor = self.calculateScaleFactor(pictureSize: pictureSize, targetSize: targetSize)
                var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                let transformedPath = (path.cgPath).copy(using: &affineTransform)

                layer.path = transformedPath
                layer.lineWidth = strokeWidth
                layer.strokeColor = strokeColor
                layer.fillColor = UIColor.white.cgColor
                pathLayers.append(layer)
            }

            DispatchQueue.main.async {

                completionHandler(pathLayers)

            }
        }
    }

    func calculatePictureBounds(pictureSize size: CGSize, rect: CGRect) -> CGSize {

        let maxX = rect.maxX
        let maxY = rect.maxY

        let newsizeWidth = size.width > maxX ? size.width : maxX
        let newsizeHeight = size.height > maxY ? size.height : maxY

        return CGSize(width: newsizeWidth, height: newsizeHeight)
    }

    func calculateScaleFactor(pictureSize: CGSize, targetSize: CGSize) -> CGFloat {

        let boundingBoxAspectRatio = pictureSize.width/pictureSize.height
        let viewAspectRatio = targetSize.width/targetSize.height

        let scaleFactor: CGFloat
        if boundingBoxAspectRatio > viewAspectRatio {
            // Width is limiting factor
            scaleFactor = targetSize.width/pictureSize.width
        } else {
            // Height is limiting factor
            scaleFactor = targetSize.height/pictureSize.height
        }

        return scaleFactor
    }

}
