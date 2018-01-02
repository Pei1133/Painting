//
//  PictureGridCollectionViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/19.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG
import Firebase
import Nuke

class PictureGridCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "Cell"

    var fullScreenSize = CGSize()

    var flowLayout = UICollectionViewFlowLayout()

    var imageURLs: [URL] = [] {

        didSet {
            self.collectionView?.reloadData()
            print("AAA:\(imageURLs)")
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        collectionView?.allowsSelection = true

        fullScreenSize = UIScreen.main.bounds.size

        setUpLayout()

        setUpCollectionView()

        downloadLibraryPictures()

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
        flowLayout.minimumLineSpacing = 10

        // 設置 header 及 footer 的尺寸
        flowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 20)
        flowLayout.footerReferenceSize = CGSize(width: fullScreenSize.width, height: 20)

    }

    func downloadLibraryPictures() {

        for i in 0...13 {
            let libraryRef = Storage.storage().reference().child("libraryPictures").child("\(i).svg")

                libraryRef.downloadURL { (url, err) in
                    if let error = err {
                        print(error)
                    } else {
                        guard let url = url else { return }
                        print("\(i) : \(url)")
                        self.imageURLs.append(url)
                    }
                }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureGridCollectionViewCell else {
            fatalError() }

        let imageURL = imageURLs[indexPath.row]
        if cell.pictureImageView.image == nil {

        let renderParameter = PathProvider.renderCellPaths(url: imageURL, imageView: cell.pictureImageView)
//        cell.pictureImageView = renderParameter.imageView
//        cell.pictureImageView.image = #imageLiteral(resourceName: "icon_photo")
        cell.pictureImageView.contentMode = .scaleAspectFill
        Nuke.loadImage(with: imageURL, into: renderParameter.imageView)
        
        }
        
        // [Firebase] Download to a local file
//        let islandRef = Storage.storage().reference().child("libraryPictures").child("2.svg")
//        let localURL = URL(string: "\(islandRef)")!
//
//        islandRef.write(toFile: localURL) { (url, err) in
//            if let error = err {
//                print(error)
//            } else {
//
//                let renderParameter = PathProvider.renderCellPaths(url: url!, imageView: cell.pictureImageView)
//                cell.pictureImageView = renderParameter.imageView
//
//            }
//        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let imageURL = imageURLs[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let paintingViewController = storyboard.instantiateViewController(withIdentifier: "Painting") as? PaintingViewController else { return }

        paintingViewController.url = imageURL
        self.navigationController?.pushViewController(paintingViewController, animated: true)

        // Present next viewcontroller
//        let name = picture.name
//        let url = picture.imageURL
//        let paintingViewController = PaintingViewController(name: name, url: url)
//        self.present(paintingViewController, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
