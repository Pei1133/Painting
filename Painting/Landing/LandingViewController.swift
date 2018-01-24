//
//  LandingViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2018/1/21.
//  Copyright © 2018年 黃珮鈞. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    var timer: Timer!
    @IBOutlet weak var landingImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGif()
        setUpBackgroundColor()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // present to LibraryPage
            let layout = UICollectionViewLayout()
            let vc = PictureGridCollectionViewController(collectionViewLayout: layout)
            let pictureGridCollectionViewController = UINavigationController(rootViewController: vc)
            self.present(pictureGridCollectionViewController, animated: true, completion: nil)
        }
    }

    // MARK: - Set up
    func setUpGif() {

        // An animated UIImage
        self.landingImageView.image = UIImage.gif(name: "landing")
        view.bringSubview(toFront: landingImageView)
    }

    func setUpBackgroundColor() {
        view.backgroundColor = Colors.backgroundGreen

//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = UIScreen.main.bounds
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.colors = [Colors.backgroundGreen.cgColor, Colors.darkBackgroundGreen.cgColor]
//        self.view.layer.addSublayer(gradientLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//         Dispose of any resources that can be recreated.
    }
}
