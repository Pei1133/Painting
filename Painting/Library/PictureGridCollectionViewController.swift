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

    var fullScreenSize = UIScreen.main.bounds.size

    var flowLayout = UICollectionViewFlowLayout()

    var imageURLs: [URL] = [] {

        didSet {
            self.collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        downloadLibraryPictures()
        setUpLayout()
        setUpCollectionView()
        setUpGradientColor()

    }

    func setUpCollectionView() {

        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)

        self.collectionView?.allowsSelection = true

        // Register cell
        let nib = UINib(nibName: "PictureGridCollectionViewCell", bundle: nil)

        self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)

    }

    func setUpGradientColor() {

        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.colors = [Colors.paleTurquoise.cgColor, Colors.skyBlue.cgColor]

        let backgroundView = UIView()
//        backgroundView.frame = UIScreen.main.bounds
        backgroundView.layer.addSublayer(gradient)
        collectionView?.backgroundView = backgroundView

    }

    func setUpLayout() {

        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        flowLayout.sectionInset = UIEdgeInsets(top: 25, left: 18, bottom: 5, right: 18)

        // 設置每個 cell 的尺寸
        flowLayout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/2 - 36, height: CGFloat(fullScreenSize.width)/2 - 36)

        // 設置每一行的間距
        flowLayout.minimumLineSpacing = 20

        // 設置 header 及 footer 的尺寸
        flowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 60)
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

        if let sublayers = cell.pictureImageView.layer.sublayers {

            for sublayer in sublayers {

                sublayer.removeFromSuperlayer()
            }
        }

        let provider = PathProvider()

            provider.renderCellPaths(
                url: imageURL,
                targetSize: cell.pictureImageView.bounds.size,
                completionHandler: { (pathLayers: [CALayer]) -> Void in

                    for pathLayer in pathLayers {

                        DispatchQueue.main.async {

                            cell.pictureImageView.layer.addSublayer(pathLayer)

                        }
                    }
                }
            )

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
