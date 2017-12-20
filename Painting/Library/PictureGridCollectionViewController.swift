//
//  PictureGridCollectionViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/19.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit

class PictureGridCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "Cell"

    var fullScreenSize = CGSize()

    var flowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {

        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size

        setUpCollectionView()

        setUpLayout()

    }

    func setUpCollectionView() {

        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)

        self.collectionView?.backgroundColor = UIColor.lightGray

        // Register cell
        let nib = UINib(nibName: "PictureGridCollectionViewCell", bundle: nil)

        self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)

    }

    func setUpLayout() {

        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        flowLayout.sectionInset = UIEdgeInsets(top: 35, left: 15, bottom: 5, right: 15)

        // 設置每個 cell 的尺寸
        flowLayout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/2 - 20, height: CGFloat(fullScreenSize.width)/2 - 20)
        print(flowLayout.itemSize)

        // 設置每一行的間距
        //        flowLayout.minimumLineSpacing = 25

        // 設置 header 及 footer 的尺寸
//        flowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 40)
//        flowLayout.footerReferenceSize = CGSize(width: fullScreenSize.width, height: 40)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureGridCollectionViewCell else {
            return PictureGridCollectionViewCell() }

        cell.previewImageView.backgroundColor = UIColor.white

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//    // UICollectionViewDelegateFlowLayout
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 154, height: 160)
//    }
//
//    // 设置每一个cell的列间距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//
//    // 设置每一个cell最小行间距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//
//     // 设置cell和视图边的间距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5) // margin between cells
//    }
}
