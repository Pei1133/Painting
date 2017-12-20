//
//  PictureGridCollectionViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/19.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit

class PictureGridCollectionViewController: UICollectionViewController {

    var fullScreenSize: CGSize!

    var flowLayout = UICollectionViewFlowLayout()

    private let reuseIdentifier = "PictureGridCollectionViewCell"

    override func viewDidLoad() {

        super.viewDidLoad()
//        self.flowLayout = UICollectionViewFlowLayout()

        fullScreenSize = UIScreen.main.bounds.size

//        setUpLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.minimumLineSpacing = 5

        flowLayout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/3 - 10.0, height: CGFloat(fullScreenSize.width)/3 - 10.0)

        flowLayout.headerReferenceSize = CGSize(
            width: fullScreenSize.width, height: 40)
        flowLayout.footerReferenceSize = CGSize(
            width: fullScreenSize.width, height: 40)
        print(collectionView?.frame)

        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: flowLayout)

        print(collectionView?.frame)

        self.collectionView?.backgroundColor = UIColor.yellow

        // Register cell
        let nib = UINib(nibName: "PictureGridCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 6

    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        print("+++++")

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureGridCollectionViewCell else {
            return PictureGridCollectionViewCell() }

        cell.previewImageView.backgroundColor = UIColor.red

        return cell
    }

    // UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 154, height: 160)
    }

    // 设置每一个cell的列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    // 设置每一个cell最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

     // 设置cell和视图边的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5) // margin between cells
    }

    func setUpLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 5

        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/3 - 10.0, height: CGFloat(fullScreenSize.width)/3 - 10.0)

        layout.headerReferenceSize = CGSize(
            width: fullScreenSize.width, height: 40)
        layout.footerReferenceSize = CGSize(
            width: fullScreenSize.width, height: 40)
    }
}
