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

    @IBOutlet private(set) weak var pictureView: UIView!
    
    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setUpPictureView()

    }

    // MARK: Set Up

    private func setUpPictureView() {

        let view = pictureView!

        view.clipsToBounds = true

        view.contentMode = .center

        view.layer.borderColor = UIColor(
            red: 0.0 / 255.0,
            green: 0.0 / 255.0,
            blue: 0.0 / 255.0,
            alpha: 1.0
            ).cgColor

        view.layer.borderWidth = 0.2

        view.backgroundColor = UIColor(
            red: 255.0 / 255.0,
            green: 255.0 / 255.0,
            blue: 201.0 / 255.0,
            alpha: 1.0
            )

//        imageView.layer.cornerRadius = 1.0

    }

}
