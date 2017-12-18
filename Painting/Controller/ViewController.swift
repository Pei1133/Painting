//
//  ViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/14.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG

class ViewController: UIViewController, colorDelegate, UIScrollViewDelegate {

    @IBOutlet weak var colorPicker: ColorPicker!
    var pickedColor: UIColor = UIColor.black
    var paths = [SVGBezierPath]()
    let url = Bundle.main.url(forResource: "chicken", withExtension: "svg")!

    var scrollView: UIScrollView!
    var imageView = UIImageView()
    var fullSize: CGSize!

//    var red: CGFloat = 0.0
//    var green: CGFloat = 0.0
//    var blue: CGFloat = 0.0
//
//    @IBAction func colorsPicked(_ sender: AnyObject) {
//        if sender.tag == 0 {
//            (red, green, blue) = (1, 0, 0)
//        }else if sender.tag == 1 {
//            (red, green, blue) = (0, 0, 1)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fullSize = UIScreen.main.bounds.size
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        self.paths = paths
        colorPicker.delegate = self
        renderPaths()
//        showSVG()
        setUpScrollViewAndImageView()

     // Step1 :- Initialize Tap Event on view where your UIBeizerPath Added.
        // Catch layer by tap detection
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapDetected(tapRecognizer:)))
        self.imageView.addGestureRecognizer(tapRecognizer)
    }

    func pickedColor(color: UIColor) {
        self.pickedColor = color
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
//            layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//            layer.frame = self.imageView.bounds
//            layer.contentsGravity = kCAGravityResizeAspect
            self.imageView.layer.addSublayer(layer)
            print(layer.bounds)
        }
    }

    // Step 2 :- Make "tapDetected" method
    @objc public func tapDetected(tapRecognizer: UITapGestureRecognizer) {
        let tapLocation: CGPoint = tapRecognizer.location(in: self.imageView)
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
//                layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//                layer.fillColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
                layer.fillColor = pickedColor.cgColor
                self.imageView.layer.addSublayer(layer)
            } else {
                print("no color!!")
            }
        }
    }

    func setUpScrollViewAndImageView() {

        // Set up ImageView
//        imageView.image = UIImage(named: "icon_photo")
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true

        // Set up ScrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 375, height: 487))
//        scrollView.contentSize = imageView.bounds.size
//        scrollView.contentSize = CGSize(width: fullSize.width * 2, height: fullSize.height)
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
//        scrollView.contentMode = .scaleAspectFit
//        scrollView.isScrollEnabled = false

        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        // ZoomScale Setting
        scrollView.delegate = self
//        scrollView.setZoomScale(0.5, animated: false)
        scrollView.zoomScale = 0.8
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0

        print("---------")
        print(imageView.frame.size.width)
        print(scrollView.frame.size)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // ScrollView
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150.0).isActive = true

        // ImageView
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func calculateScaleFactor() -> CGFloat {

        let boundingBoxAspectRatio = scrollView.contentSize.width/scrollView.contentSize.height
        let viewAspectRatio = self.view.bounds.width/(self.view.bounds.height - 110)

        let scaleFactor: CGFloat
        if boundingBoxAspectRatio > viewAspectRatio {
            // Width is limiting factor
            scaleFactor = self.view.bounds.width/scrollView.contentSize.width
        } else {
            // Height is limiting factor
            scaleFactor = (self.view.bounds.height - 110)/scrollView.contentSize.height
        }

        return scaleFactor

        //        let scaleFactor = transformRatio()
        //
        //        var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        //
        //        let transformedPath = (path.cgPath).copy(using: &affineTransform)
        //
        //        let layer = CAShapeLayer()
        //        layer.path = transformedPath

    }
}
