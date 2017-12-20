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

    @IBOutlet private(set) weak var previewImageView: UIImageView!

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setUpPreviewImageView()

    }

    // MARK: Set Up

    private func setUpPreviewImageView() {

        let imageView = previewImageView!

        imageView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill

        imageView.layer.borderColor = UIColor(
            red: 0.0 / 255.0,
            green: 0.0 / 255.0,
            blue: 0.0 / 255.0,
            alpha: 1.0
            ).cgColor

        imageView.layer.borderWidth = 0.2

        imageView.backgroundColor = UIColor.white

//        imageView.layer.cornerRadius = 1.0

    }

}
