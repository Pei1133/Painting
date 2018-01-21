//
//  LandingViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2018/1/21.
//  Copyright © 2018年 黃珮鈞. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var landingImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundGreen

        // An animated UIImage
//        self.landingImageView.image = UIImage.gif(name: "landing")
        self.landingImageView.image = #imageLiteral(resourceName: "notebook")
//        // A UIImageView with async loading
//        let imageView = UIImageView()
//        imageView.loadGif(name: "landing")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
