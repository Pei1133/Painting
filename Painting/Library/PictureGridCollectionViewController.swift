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
import Crashlytics
import SVProgressHUD

class PictureGridCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "Cell"

    var fullScreenSize = UIScreen.main.bounds.size

    var flowLayout = UICollectionViewFlowLayout()

    var imageURLs: [URL] = []

    var jpgURLs: [URL] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        downloadLibraryPictures()
        downloadNewLibraryPictures()
        setUpLayout()
        setUpCollectionView()
        setUpGradientColor()
        setUpNavigationBar()
        setUpBlurEffect()
    }

    // MARK: - Set up

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
        flowLayout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/2 - 25, height: CGFloat(fullScreenSize.width)/2)

        // 設置每一行的間距
        flowLayout.minimumLineSpacing = 15

        // 設置 header 及 footer 的尺寸
        flowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: CGFloat(fullScreenSize.height)*2/7)

    }

    func setUpNavigationBar() {

        // title
//        let localTitle = NSLocalizedString("Library", comment: "")
//        self.navigationItem.title = localTitle
        self.navigationItem.title = "Library"
        let font = UIFont(name: "BradleyHandITCTT-Bold", size: 25)
        let textAttributes = [
            NSAttributedStringKey.font: font ?? UIFont.systemFont(ofSize: 25),
            NSAttributedStringKey.foregroundColor: Colors.deepCyanBlue
        ]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes

        // right button
//        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(addNew))
//        button.tintColor = Colors.deepCyanBlue
//        self.navigationItem.rightBarButtonItem = button

        // shadow
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.layer.shadowColor = UIColor(red: 93.0 / 255.0, green: 151.0 / 255.0, blue: 175.0 / 255.0, alpha: 0.85).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 4

        // hide bottom line
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc func addNew() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let paintingViewController = storyboard.instantiateViewController(withIdentifier: "Painting") as? PaintingViewController else { return }

        paintingViewController.url = URL(string: "")
        self.navigationController?.pushViewController(paintingViewController, animated: true)
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

            header.headerView.layer.shadowColor = UIColor.black.cgColor
            header.headerView.layer.shadowRadius = 3.0
            header.headerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            header.headerView.layer.shadowOpacity = 1
            return header

        default:
            return header
//            assert(false, "Unexpexted element kind!")
        }

    }

    // MARK: - Download

    func downloadLibraryPictures() {

        Database.database().reference().child("libraryPictures").observeSingleEvent(of: .value, with: {[weak self](snapshot) in

            for child in snapshot.children {
                guard let child = child as? DataSnapshot
                    else { return }

                guard let value = child.value as? [String: String],
                    let url = value["imageURL"],
                    let jpgurl = value["jpgURL"]
                    else { return }

                let imageURL = URL(string: url)!
                let jpgURL = URL(string: jpgurl)!
                self?.imageURLs.append(imageURL)
                self?.jpgURLs.append(jpgURL)
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
            }, withCancel: nil)
    }

    func downloadNewLibraryPictures() {

        Database.database().reference().child("libraryPictures").observe(.childAdded, with: {[weak self](snapshot) in

            for child in snapshot.children {
                guard let child = child as? DataSnapshot
                    else { return }

                guard let value = child.value as? [String: String],
                    let url = value["imageURL"],
                    let jpgurl = value["jpgURL"]
                    else { return }

                let imageURL = URL(string: url)!
                let jpgURL = URL(string: jpgurl)!
                self?.imageURLs.append(imageURL)
                self?.jpgURLs.append(jpgURL)
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
            }, withCancel: nil)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureGridCollectionViewCell else {
            fatalError() }

        cell.pictureImageView.image = #imageLiteral(resourceName: "iconCircle")

        if jpgURLs.count > indexPath.row {

            let jpgURL = jpgURLs[indexPath.row]

            // load JPG
            Nuke.loadImage(
                with: jpgURL,
                into: cell.pictureImageView
            )
        }

//        let imageURL = imageURLs[indexPath.row]

//    // remove subviews & load SVG
//        let subviews = cell.pictureImageView.subviews
//        for subview in subviews {
//            subview.removeFromSuperview()
//        }
//
//        let svgImageView = SVGImageView.init(contentsOf: imageURL)
//        svgImageView.frame = cell.pictureImageView.bounds
//        cell.pictureImageView.contentMode = .scaleAspectFit
//        cell.pictureImageView.addSubview(svgImageView)

//    // remove sublayers & render New CellPaths
//        if let sublayers = cell.pictureImageView.layer.sublayers {
//
//            for sublayer in sublayers {
//                sublayer.removeFromSuperlayer()
//            }
//        }
//        let provider = PathProvider()
//
//        provider.renderCellPaths(
//            url: imageURL,
//            targetSize: cell.pictureImageView.bounds.size,
//            completionHandler: { (pathLayers: [CALayer]) -> Void in
//
//                for pathLayer in pathLayers {
//
//                    cell.pictureImageView.layer.addSublayer(pathLayer)
//                }
//            }
//        )
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.setDefaultAnimationType(.native)
        let imageURL = self.imageURLs[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let provider = PathProvider()

        provider.renderPaths(
            url: imageURL,
            targetSize: self.view.bounds.size,
            completionHandler: { (pathLayers: [CALayer], pictureSize: CGSize, _ pathCount: Int) -> Void in

                guard let paintingViewController = storyboard.instantiateViewController(withIdentifier: "Painting") as? PaintingViewController else { return }

                paintingViewController.pictureSize = pictureSize
                paintingViewController.pathCount = pathCount
                paintingViewController.pathLayers = pathLayers
                paintingViewController.url = imageURL
                self.navigationController?.pushViewController(paintingViewController, animated: true)
            }
        )

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
