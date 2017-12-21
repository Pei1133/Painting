//
//  PictureGridCollectionViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/19.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG

class PictureGridCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "Cell"

    var fullScreenSize = CGSize()

    var flowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {

        super.viewDidLoad()

        collectionView?.allowsSelection = true

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
        flowLayout.sectionInset = UIEdgeInsets(top: 25, left: 15, bottom: 5, right: 15)

        // 設置每個 cell 的尺寸
        flowLayout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/2 - 20, height: CGFloat(fullScreenSize.width)/2 - 20)

        // 設置每一行的間距
//        flowLayout.minimumLineSpacing = 15

        // 設置 header 及 footer 的尺寸
//        flowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 40)
//        flowLayout.footerReferenceSize = CGSize(width: fullScreenSize.width, height: 40)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureGridCollectionViewCell else {
            return PictureGridCollectionViewCell() }

        let picture = pictures[indexPath.row]

        let url = picture.imageURL

    print("1:\(cell.pictureImageView.frame.size)")
    print("2:\(cell.pictureImageView.bounds.size)")
    print("3:\(cell.pictureImageView.layer.frame.size)")
    print("4:\(cell.pictureImageView.layer.bounds.size)")

        let renderParameter = PathProvider.renderPaths(url: url, imageView: cell.pictureImageView)
        cell.pictureImageView = renderParameter.imageView
        cell.pictureImageView.layer.frame = CGRect(x: 0, y: 0, width: renderParameter.pictureSize.width, height: renderParameter.pictureSize.height)

//        cell.pictureImageView.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.4)
//        cell.pictureImageView.frame = cell.pictureView.bounds
//        cell.pictureView.addSubview(cell.pictureImageView)
//        svgImageView.frame = self.view.bounds

//        let svgImageView = SVGImageView.init(contentsOf: url)
//        svgImageView.frame = cell.pictureImageView.bounds
//        cell.pictureView.addSubview(svgImageView)

        return cell

    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let picture = pictures[indexPath.row]

//        let name = picture.name
//        let url = picture.imageURL

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let paintingViewController = storyboard.instantiateViewController(withIdentifier: "Painting") as? PaintingViewController else { return }
        
        paintingViewController.name = picture.name
        paintingViewController.url = picture.imageURL

//        let paintingViewController = PaintingViewController(name: name, url: url)

//        self.present(paintingViewController, animated: true, completion: nil)

        self.navigationController?.pushViewController(paintingViewController, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
