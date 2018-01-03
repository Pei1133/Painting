//
//  PictureGridCollectionViewCell.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/19.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit

class PictureGridCollectionViewCell: UICollectionViewCell {

    // MARK: Property

    @IBOutlet weak var pictureImageView: UIImageView!

//    @IBOutlet weak var pictureView: UIView!

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setUpPictureImageView()

//        setUpPictureView()

    }

    // MARK: Set Up

    private func setUpPictureImageView() {

        let imageView = pictureImageView!

        imageView.clipsToBounds = true

        imageView.contentMode = .center

        imageView.layer.cornerRadius = 1.0

        imageView.layer.borderWidth = 0.2

        imageView.backgroundColor = UIColor.white

        imageView.layer.shadowColor = UIColor.black.cgColor

        imageView.layer.shadowRadius = 1.0

        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)

        imageView.layer.shadowOpacity = 0.26

    }

//    private func setUpPictureView() {
//
//        let view = pictureView!
//
//        view.clipsToBounds = true
//
//        view.contentMode = .center
//
//        view.layer.cornerRadius = 1.0
//
//        view.layer.borderWidth = 0.2
//
//        view.backgroundColor = UIColor.blue
//
////        view.backgroundColor = UIColor(
////            red: 255.0 / 255.0,
////            green: 255.0 / 255.0,
////            blue: 201.0 / 255.0,
////            alpha: 1.0
////        )
//
//        view.layer.shadowColor = UIColor.black.cgColor
//
//        view.layer.shadowRadius = 1.0
//
//        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//
//        view.layer.shadowOpacity = 0.26
//
//    }
}
