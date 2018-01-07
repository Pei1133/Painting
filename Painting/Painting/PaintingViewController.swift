//
//  PaintingViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/14.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG

class PaintingViewController: UIViewController, UIScrollViewDelegate, ColorDelegate, CustomImageViewTouchEventDelegate {

    func pickedColor(color: UIColor) {
        self.pickedColor = color
    }
    @IBOutlet weak var paintingView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var color0: UIButton!
    @IBOutlet weak var color1: UIButton!
    @IBOutlet weak var color2: UIButton!
    @IBOutlet weak var color3: UIButton!
    @IBOutlet weak var color4: UIButton!
//    @IBOutlet weak var selectColorView: UIView!
    @IBOutlet weak var colorSlider: ColorSlider!
    @IBOutlet weak var sliderView: UIView!

    @IBAction func tapColorSlider(_ sender: ColorSlider) {
        let percentage = CGFloat(colorSlider.value / colorSlider.maximumValue)

        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var hue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if self.pickedColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {

            if percentage >= 0.5 {

                self.sliderColor = UIColor(hue: hue, saturation: 1-percentage, brightness: percentage, alpha: alpha)
            }else {

                self.sliderColor = UIColor(hue: hue, saturation: saturation, brightness: percentage, alpha: alpha)
                print("pickedColor:\(pickedColor)", "sliderColor:\(sliderColor)")
            }
        }else {
            print("sliderColor error")
        }

    }

//        var r: CGFloat=0, g: CGFloat=0, b: CGFloat=0, a: CGFloat=0
//
//        if(self.pickedColor.getRed(&r, green: &g, blue: &b, alpha: &a)) {
//            let minV: CGFloat = CGFloat(min(r, g, b))
//            let maxV: CGFloat = CGFloat(max(r, g, b))
//            let saturation: CGFloat = 1-(minV/maxV)
//
//            if maxV == 0 {
//
//                self.sliderColor = UIColor(hue: hue, saturation: 0, brightness: percentage, alpha: alpha)
//            }else {
//                self.sliderColor = UIColor(red: min(r - percentage, 1.0),
//                                           green: min(g - percentage, 1.0),
//                                           blue: min(b - percentage, 1.0),
//                                           alpha: a)
//                print("pickedColor:\(pickedColor)","sliderColor:\(sliderColor)")
//            }
//        }else {
//            print("sliderColor error")
//        }
//    }

    var isFill: Bool = true

    @IBAction func tapColor(_ sender: UIButton) {

        pickedColor = sender.backgroundColor!

    }

//    @IBAction func tapSave(_ sender: Any) {
//        
//        UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
//    }

    @IBOutlet private(set) weak var colorPicker: ColorPicker!

    var pickedColor = Colors.lightSkyBlue {
        didSet {
            setUpSliderView(pickedColor)
        }
    }
    var sliderColor = Colors.lightSkyBlue {
        didSet {
//            colorSlider.thumbTintColor = sliderColor
        }
    }
    var adjustColor = Colors.lightSkyBlue

    let provider = PathProvider()
    var paths = [SVGBezierPath]()
    var scrollView = UIScrollView()
    var pictureView = UIView()
    var imageView = CustomImageView()
    var pictureSize = CGSize.zero

    var url: URL?

    var lastPoint = CGPoint.zero
    var swiped = false

    override func viewDidLoad() {

        super.viewDidLoad()

        colorPicker.delegate = self

        if let url = url {
            let paths = SVGBezierPath.pathsFromSVG(at: url)
            self.paths = paths

            let renderParameter = provider.renderPaths(url: url, imageView: imageView)
            self.imageView = renderParameter.imageView
            self.pictureSize = renderParameter.pictureSize

        }else {
            print("no URL")
            isFill = false
            self.pictureSize = CGSize(width: view.bounds.width, height: view.bounds.height - 200)
        }

        setUpNavigationBar()
        setUpScrollViewAndImageView()
        setUpColorPickerAndView()
        setUpButton()
        setUpColorSlider()
        setUpSliderView(pickedColor)
//        setupStackView()
//        showSVG()

     // Step1 :- Initialize Tap Event on view where your UIBeizerPath Added.
        // Catch layer by tap detection
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaintingViewController.tapDetected(tapRecognizer:)))
        self.imageView.addGestureRecognizer(tapRecognizer)

    }

    // Step 2 :- Make "tapDetected" method
    @objc public func tapDetected(tapRecognizer: UITapGestureRecognizer) {

        let tapLocation: CGPoint = tapRecognizer.location(in: self.imageView)
        self.hitTest(tapLocation: CGPoint(x: (tapLocation.x), y: (tapLocation.y)))

    }

    // Step 3 :- Make "hitTest" final method
    private func hitTest(tapLocation: CGPoint) {

        if isFill == true {
            for path in paths {

                if path.contains(tapLocation) {

//                    print("I am in \(path.svgAttributes)")
                    let strokeWidth = CGFloat(2.0)
                    let strokeColor = UIColor.gray.cgColor

                    let layer = CAShapeLayer()
                    layer.path = path.cgPath
                    layer.lineWidth = strokeWidth
                    layer.strokeColor = strokeColor
                    layer.fillColor = sliderColor.cgColor
                    self.imageView.layer.addSublayer(layer)

                } else {
                    print("no color!")
                }
            }
        }
    }

    func showSVG() {
        let svgImageView = SVGImageView.init(contentsOf: url!)
        svgImageView.frame = self.view.bounds
        view.addSubview(svgImageView)
    }

    // MARK: - Set up

    func setUpNavigationBar() {
        // title
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationItem.title = "Color Your Own"
        let font = UIFont(name: "BradleyHandITCTT-Bold", size: 25)
        let textAttributes = [
            NSAttributedStringKey.font: font ?? UIFont.systemFont(ofSize: 25),
            NSAttributedStringKey.foregroundColor: Colors.deepCyanBlue
        ]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes

        // left button
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-chervon"), style: .plain, target: self, action: #selector(goBack))
        leftButton.tintColor = Colors.deepCyanBlue
        self.navigationItem.leftBarButtonItem = leftButton

        // right button
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(share))
        rightButton.tintColor = Colors.deepCyanBlue
        self.navigationItem.rightBarButtonItem = rightButton

        // gradient
        let gradient = CAGradientLayer()
        var frameAndStatusBar = self.navigationController?.navigationBar.bounds
        frameAndStatusBar?.size.height += 20
        gradient.frame = frameAndStatusBar!
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: (frameAndStatusBar?.size.width)!, height: (frameAndStatusBar?.size.height)!)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.colors = [Colors.lightBlue.cgColor, Colors.skyBlue.cgColor]
        self.navigationController?.navigationBar.setBackgroundImage(layerTransImage(fromLayer: gradient), for: .default)

        // shadow
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.layer.shadowColor = UIColor(red: 53/255.0, green: 184/255.0, blue: 208/255.0, alpha: 0.85).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 4
    }

    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: paintingView.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: paintingView.heightAnchor, multiplier: 1/5).isActive = true
        stackView.centerYAnchor.constraint(equalTo: paintingView.centerYAnchor, constant: (paintingView.frame.height) / 5).isActive = true
        stackView.widthAnchor.constraint(equalTo: colorPicker.widthAnchor, multiplier: 3/4).isActive = true
    }

    // MARK: - Transform

    //讓layer轉型成UIImage
    func layerTransImage(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)

        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func share(_ sender: Any) {

        let image = UIImage.init(view: imageView)

        let imageToShare = [image]

        let PaintingViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)

        self.present(PaintingViewController, animated: true, completion: nil)
    }

//    func setUpNewImageView(){
//        imageView.contentMode = .center
//        imageView.backgroundColor = .clear
//        imageView.isUserInteractionEnabled = true
//        imageView.frame = CGRect(x: 0, y: 0, width: pictureSize.width, height: pictureSize.height)
//        imageView.delegate = self
//        view.addSubview(imageView)
//    }

    func setUpScrollViewAndImageView() {

        // Set up ImageView
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.frame = CGRect(x: 0, y: 0, width: pictureSize.width, height: pictureSize.height)
//        imageView.layer.borderColor = UIColor.red.cgColor
//        imageView.layer.borderWidth = 3.0
        imageView.delegate = self

        // Set up View
        pictureView.frame = CGRect(x: 0, y: 0, width: pictureSize.width, height: pictureSize.height)
        pictureView.backgroundColor = UIColor.clear

        // Set up ScrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - paintingView.frame.height))
        scrollView.contentSize = imageView.frame.size
        scrollView.backgroundColor = UIColor.white
//        scrollView.alwaysBounceVertical = true
//        scrollView.alwaysBounceHorizontal = true

        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(pictureView)
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

    func setUpColorPickerAndView() {

        colorPicker.layer.cornerRadius = 5.0
        colorPicker.clipsToBounds = true
        colorPicker.layer.shadowColor = UIColor.black.cgColor
        colorPicker.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        colorPicker.layer.shadowOpacity = 0.3
        colorPicker.layer.shadowRadius = 2.0

//        selectColorView.backgroundColor = Colors.littleRed
//        selectColorView.layer.cornerRadius = selectColorView.frame.height * 0.5
//        selectColorView.clipsToBounds = true
    }

    func setUpButton() {
        color0.backgroundColor = Colors.littleRed
        color0.layer.cornerRadius = color0.frame.height*0.5
        color0.clipsToBounds = true
        color1.backgroundColor = Colors.lightOrange
        color1.layer.cornerRadius = color0.frame.height*0.5
        color1.clipsToBounds = true
        color2.backgroundColor = Colors.littleGreen
        color2.layer.cornerRadius = color0.frame.height*0.5
        color2.clipsToBounds = true
        color3.backgroundColor = Colors.paleTurquoise
        color3.layer.cornerRadius = color0.frame.height*0.5
        color3.clipsToBounds = true
        color4.backgroundColor = Colors.littleBlue
        color4.layer.cornerRadius = color0.frame.height*0.5
        color4.clipsToBounds = true
    }

    func setUpColorSlider() {
        colorSlider.minimumValue = 0.0
        colorSlider.maximumValue = 1.0
        colorSlider.value = 0.5
        colorSlider.isContinuous = true

        colorSlider.maximumTrackTintColor = UIColor.clear
        colorSlider.minimumTrackTintColor = UIColor.clear
    }

    func setUpSliderView(_ pickedColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = sliderView.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.black.cgColor, pickedColor.cgColor, UIColor.white.cgColor]
        self.sliderView.layer.addSublayer(gradient)

        sliderView.layer.cornerRadius = 5.0
        sliderView.clipsToBounds = true
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

    func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {

        if isFill == false {
            UIGraphicsBeginImageContext(self.pictureView.frame.size)

    //        let drawingLayer = CAShapeLayer()

            imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.pictureView.frame.width, height: self.pictureView.frame.height))

            //        let context = CGLayerGetContext(drawingLayer)
            let context = UIGraphicsGetCurrentContext()
            context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

            context?.setBlendMode(CGBlendMode.normal)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(5)
            context?.setStrokeColor(sliderColor.cgColor)
            context?.strokePath()

            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    //        drawingLayer.contents = imageView.image?.cgImage
    //        imageView.layer.contents = imageView.image?.cgImage
    //        drawingLayer.contents = UIGraphicsGetImageFromCurrentImageContext()
    //        imageView.layer.addSublayer(drawingLayer)
            UIGraphicsEndImageContext()
        }
    }

    func didTouchesBegan(touches: Set<UITouch>) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.imageView)
        }
    }

    func didTouchesMoved(touches: Set<UITouch>) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.imageView)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            self.lastPoint = currentPoint
        }
    }

    func didTouchesEnd() {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
}

extension UIImage {

    convenience init(view: UIView) {

        UIGraphicsBeginImageContext(view.bounds.size)

        view.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        self.init(cgImage: image!.cgImage!)
    }
}
