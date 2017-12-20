//
//  PictureGridCollectionViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/19.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit

class PictureGridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var fullScreenSize: CGSize!

    private let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.yellow
        
        fullScreenSize = UIScreen.main.bounds.size

//        setUpLayout()

//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        layout.minimumLineSpacing = 5
//        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/3 - 10.0, height: CGFloat(fullScreenSize.width)/3 - 10.0)
//
//        layout.headerReferenceSize = CGSize(
//            width: fullScreenSize.width, height: 40)
//        layout.footerReferenceSize = CGSize(
//            width: fullScreenSize.width, height: 40)

        // Register cell classes
        self.collectionView?.register(UINib(nibName: "PictureGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureGridCollectionViewCell else { return PictureGridCollectionViewCell() }

        cell.contentView.backgroundColor = UIColor.red

        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: PictureGridCollectionViewController, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }

    func collectionView(collectionView: PictureGridCollectionViewController, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(collectionView: PictureGridCollectionViewController, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(collectionView: PictureGridCollectionViewController, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        //        let frame : CGRect = self.view.frame
        //        let margin  = (frame.width - 90 * 3) / 6.0
        return UIEdgeInsets(top: 1, left: 1, bottom: 10, right: 1) // margin between cells
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
