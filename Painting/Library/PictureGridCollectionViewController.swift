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

    var imageURLs: [URL] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        downloadLibraryPictures()
        setUpLayout()
        setUpCollectionView()
        setUpGradientColor()
        setUpNavigationBar()
        setUpBlurEffect()

    }

    func setUpCollectionView() {

        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)

        self.collectionView?.allowsSelection = true

        // Register cell
        let nib = UINib(nibName: "PictureGridCollectionViewCell", bundle: nil)

        self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)

        self.collectionView?.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
    }

    func setUpGradientColor() {

        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.colors = [Colors.paleTurquoise.cgColor, Colors.skyBlue.cgColor, Colors.lightGreen.cgColor, Colors.cream.cgColor, Colors.lightRed.cgColor]

        let backgroundView = UIView()
//        backgroundView.frame = UIScreen.main.bounds
        backgroundView.layer.addSublayer(gradient)
        collectionView?.backgroundView = backgroundView

    }

    func setUpBlurEffect() {

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.backgroundView?.insertSubview(blurEffectView, belowSubview: collectionView!)
    }

    func setUpLayout() {

        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        flowLayout.sectionInset = UIEdgeInsets(top: 25, left: 18, bottom: 5, right: 18)

        // 設置每個 cell 的尺寸
        flowLayout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/2 - 25, height: CGFloat(fullScreenSize.width)/2 - 25)

        // 設置每一行的間距
        flowLayout.minimumLineSpacing = 15

        // 設置 header 及 footer 的尺寸
        flowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: CGFloat(fullScreenSize.height)/3)

    }

    func downloadLibraryPictures() {

        Database.database().reference().child("libraryPictures").observe(.value, with: {(snapshot) in

            for child in snapshot.children {
                guard let child = child as? DataSnapshot
                    else { return }

                guard let value = child.value as? [String: String],
                    let url = value["imageURL"]
                else { return }

                let imageURL = URL(string: url)!
                self.imageURLs.append(imageURL)
                self.collectionView?.reloadData()
            }
        }, withCancel: nil)
    }

    func setUpNavigationBar() {

        self.navigationItem.title = "Library"
        let font = UIFont(name: "BradleyHandITCTT-Bold", size: 24)
        let textAttributes = [
            NSAttributedStringKey.font: font ?? UIFont.systemFont(ofSize: 24),
            NSAttributedStringKey.foregroundColor: Colors.deepCyanBlue
        ]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? HeaderView else {
            print("Header is wrong!")
            fatalError()
        }

        switch kind {
        case UICollectionElementKindSectionHeader:

            header.headerView.backgroundColor = Colors.skyBlue
            header.headerView.image = #imageLiteral(resourceName: "notebook")
            header.headerView.contentMode = .scaleAspectFill

            header.headerView.layer.shadowColor = UIColor.red.cgColor
            header.headerView.layer.shadowRadius = 10
            header.headerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            header.headerView.layer.shadowOpacity = 1
            return header

        default:
            assert(false, "Unexpexted element kind!")
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

                    cell.pictureImageView.layer.addSublayer(pathLayer)

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
