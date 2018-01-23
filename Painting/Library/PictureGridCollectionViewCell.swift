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

    @IBOutlet weak var pictureView: UIView!

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

//        self.backgroundColor = .lightGray

        setUpPictureImageView()

        setUpPictureView()

    }

    // MARK: Set Up

    private func setUpPictureImageView() {

        let imageView = pictureImageView!

        imageView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFit

        imageView.layer.cornerRadius = 8.0

        imageView.backgroundColor = UIColor.white

//        imageView.image = #imageLiteral(resourceName: "iconCircle")

    }

    private func setUpPictureView() {

        let view = pictureView!

        view.contentMode = .center

        view.layer.cornerRadius = 8.0

        view.backgroundColor = UIColor.white

        view.layer.borderWidth = 0.5

        view.layer.borderColor = UIColor.clear.cgColor

        view.layer.shadowColor = Colors.coolGray.cgColor

        view.layer.shadowRadius = 5

        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)

        view.layer.shadowOpacity = 1

    }
}
