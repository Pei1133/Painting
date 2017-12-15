//
//  ViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/14.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG

class ViewController: UIViewController {

    var paths = [SVGBezierPath]()
    let url = Bundle.main.url(forResource: "chicken", withExtension: "svg")!

    @IBOutlet weak var imageView: UIImageView!
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        self.paths = paths

//        showSVG()
        renderPaths()

     // Step1 :- Initialize Tap Event on view where your UIBeizerPath Added.
        // Catch layer by tap detection
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapDetected(tapRecognizer:)))
        self.view.addGestureRecognizer(tapRecognizer)
    }

    func showSVG() {
        let svgImageView = SVGImageView.init(contentsOf: url)
        svgImageView.frame = self.view.bounds
        view.addSubview(svgImageView)
    }

    func renderPaths() {
        let strokeWidth = CGFloat(1.0)
        let strokeColor = UIColor.black.cgColor

        for path in paths {
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            layer.fillColor = UIColor.white.cgColor

//            layer.frame = self.view.bounds
//            print(layer.frame)
//            layer.contentsGravity = kCAGravityCenter
            self.view.layer.addSublayer(layer)
        }
    }

    // Step 2 :- Make "tapDetected" method
    @objc public func tapDetected(tapRecognizer: UITapGestureRecognizer) {
        let tapLocation: CGPoint = tapRecognizer.location(in: self.view)
        self.hitTest(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y))
    }

    // Step 3 :- Make "hitTest" final method
    private func hitTest(tapLocation: CGPoint) {

        for path in paths {
            if path.contains(tapLocation) {
                print("I am in \(path.svgAttributes)")
                let strokeWidth = CGFloat(2.0)
                let strokeColor = UIColor.gray.cgColor

                let layer = CAShapeLayer()
                layer.path = path.cgPath
                layer.lineWidth = strokeWidth
                layer.strokeColor = strokeColor
//                layer.fillColor = UIColor.blue.cgColor
                layer.fillColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor

                self.view.layer.addSublayer(layer)

            } else {
                print("ooops! taped on other position in view!!")
            }
        }
    }
    @IBAction func colorsPicked(_ sender: AnyObject) {
        if sender.tag == 0 {
            (red, green, blue) = (1, 0, 0)
        }else if sender.tag == 1 {
            (red, green, blue) = (0, 0, 1)
        }
    }
}
