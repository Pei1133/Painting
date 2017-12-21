//
//  PaintingViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/14.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG

class PaintingViewController: UIViewController, UIScrollViewDelegate, colorDelegate {

    @IBOutlet private(set) weak var colorPicker: ColorPicker!
    var pickedColor: UIColor = UIColor.brown
    var paths = [SVGBezierPath]()
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    var pictureSize = CGSize.zero

    var name: String?
    var url: URL?
/*
    init(name: String, url: URL) {

        self.name = name
        self.url = url
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }
*/
    override func viewDidLoad() {

        super.viewDidLoad()

        view.bringSubview(toFront: colorPicker)

        view.backgroundColor = UIColor.white
        ColorPicker.shared.delegate = self
        ColorPicker.shared.selectedColor(sColor: ColorPicker.shared.selectedColor)

        let paths = SVGBezierPath.pathsFromSVG(at: url!)
        self.paths = paths

        let renderParameter = PathProvider.renderPaths(url: url!, imageView: imageView)
        self.imageView = renderParameter.imageView
        self.pictureSize = renderParameter.pictureSize

        setUpScrollViewAndImageView()
//        showSVG()

     // Step1 :- Initialize Tap Event on view where your UIBeizerPath Added.
        // Catch layer by tap detection
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaintingViewController.tapDetected(tapRecognizer:)))
        self.imageView.addGestureRecognizer(tapRecognizer)

    }

    func pickedColor(color: UIColor) {
        
        DispatchQueue.main.async {
            self.pickedColor = color
            self.loadView()
        }
 
    }

    func showSVG() {

        let svgImageView = SVGImageView.init(contentsOf: url!)
        svgImageView.frame = self.view.bounds
        view.addSubview(svgImageView)
        print("svgImageView.bounds:\(svgImageView.bounds)")
        print("svgImageView.frame:\(svgImageView.frame)")

    }

    // Step 2 :- Make "tapDetected" method
    @objc public func tapDetected(tapRecognizer: UITapGestureRecognizer) {

        let tapLocation: CGPoint = tapRecognizer.location(in: self.imageView)
        self.hitTest(tapLocation: CGPoint(x: (tapLocation.x), y: (tapLocation.y)))

    }

    // Step 3 :- Make "hitTest" final method
    private func hitTest(tapLocation: CGPoint) {

        for path in paths {

            if path.contains(tapLocation) {

//                print("I am in \(path.svgAttributes)")
                let strokeWidth = CGFloat(2.0)
                let strokeColor = UIColor.gray.cgColor

                let layer = CAShapeLayer()
                layer.path = path.cgPath
                layer.lineWidth = strokeWidth
                layer.strokeColor = strokeColor
                layer.fillColor = pickedColor.cgColor
                self.imageView.layer.addSublayer(layer)

            } else {

                print("no color!")

            }
        }
    }

    func setUpScrollViewAndImageView() {

        // Set up ImageView
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        imageView.frame = CGRect(x: 0, y: 0, width: pictureSize.width, height: pictureSize.height)

        // Set up ScrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 150))
        scrollView.contentSize = imageView.frame.size
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true

        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        // ZoomScale Setting
        scrollView.delegate = self
        scrollView.zoomScale = 0.8
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3.0

    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return imageView
    }

    // 為了讓圖片縮小填滿且有Aspect Fit
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {

        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height

        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale

    }

    // 呼叫updateMinZoomScaleForSize
    override func viewWillLayoutSubviews() {

        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)

    }

    // 讓圖片置中,每次縮放之後會被呼叫
    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)

    }

//    override func viewWillLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        // ScrollView
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150.0).isActive = true
//
//        // ImageView
//        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
//
//    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
