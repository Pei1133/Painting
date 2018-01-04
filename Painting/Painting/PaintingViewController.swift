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

    @IBOutlet weak var fillColorButton: UIButton!
    @IBOutlet weak var paintColorButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var selectColorView: UIView!
    @IBOutlet weak var colorSlider: ColorSlider!
    @IBOutlet weak var sliderView: UIView!
    var isFill: Bool = true

    @IBAction func tapFillColor(_ sender: Any) {

        isFill = true
        fillColorButton.tintColor = Colors.littleBlue
        paintColorButton.tintColor = Colors.skyBlue
    }

    @IBAction func tapPaintColor(_ sender: Any) {

        isFill = false
        fillColorButton.tintColor = Colors.skyBlue
        paintColorButton.tintColor = Colors.littleBlue
    }

//    @IBAction func tapSave(_ sender: Any) {
//        
//        UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
//    }

    @IBOutlet private(set) weak var colorPicker: ColorPicker!
//    var brightnessColors = [UIColor.white.cgColor, Colors.littleRed.cgColor]
//    var darknessColors = [Colors.littleRed.cgColor, UIColor.black.cgColor]
//    var adjustColor = Colors.blue {
//        didSet {
//            colorSlider.thumbTintColor = adjustColor
//            brightnessColors = [UIColor.white.cgColor, adjustColor.cgColor]
//            darknessColors = [adjustColor.cgColor, UIColor.black.cgColor]
//            onSliderChange(sender: colorSlider)
//        }
//    }

    var pickedColor = Colors.littleRed {
        didSet {
//            adjustColor = self.adjustColor(pickedColor, sliderRatio)
//            colorSlider.thumbTintColor = pickedColor
//            brightnessColors = [UIColor.white.cgColor, pickedColor.cgColor]
//            darknessColors = [pickedColor.cgColor, UIColor.black.cgColor]
            setUpSliderView(pickedColor)
            self.selectColorView.backgroundColor = pickedColor
        }
    }

//    var sliderRatio: CGFloat = 0.5 {
//        didSet {
//            adjustColor = self.adjustColor(pickedColor, sliderRatio)
//        }
//    }
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

        let paths = SVGBezierPath.pathsFromSVG(at: url!)
        self.paths = paths

        let renderParameter = provider.renderPaths(url: url!, imageView: imageView)
        self.imageView = renderParameter.imageView
        self.pictureSize = renderParameter.pictureSize

        setUpNavigationBar()
        setUpScrollViewAndImageView()
        setUpColorPickerAndView()
        setUpButton()
        setUpColorSlider()
        onSliderChange(sender: colorSlider)
        colorSlider.addTarget(
                    self,
                    action:
                    #selector(self.onSliderChange),
                    for: UIControlEvents.valueChanged)
        setUpSliderView(pickedColor)
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

                    print("I am in \(path.svgAttributes)")
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
    }

    func showSVG() {
        let svgImageView = SVGImageView.init(contentsOf: url!)
        svgImageView.frame = self.view.bounds
        view.addSubview(svgImageView)
    }

    func setUpNavigationBar() {
        // title
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationItem.title = "Color Your Own"
        let font = UIFont(name: "BradleyHandITCTT-Bold", size: 24)
        let textAttributes = [
            NSAttributedStringKey.font: font ?? UIFont.systemFont(ofSize: 24),
            NSAttributedStringKey.foregroundColor: Colors.deepCyanBlue
        ]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes

        // left button
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-chervon"), style: .plain, target: self, action: #selector(goBack))
        button.tintColor = Colors.deepCyanBlue
        self.navigationItem.leftBarButtonItem = button

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
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 200))
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

        selectColorView.backgroundColor = Colors.littleRed
        selectColorView.layer.cornerRadius = selectColorView.frame.height * 0.5
        selectColorView.clipsToBounds = true
    }

    func setUpButton() {

        fillColorButton.tintColor = Colors.littleBlue
//        fillColorButton.layer.borderColor = skyBlueColor.cgColor
//        fillColorButton.layer.borderWidth = 1.0
//        fillColorButton.layer.cornerRadius = fillColorButton.frame.height * 0.5
//        fillColorButton.clipsToBounds = true

        paintColorButton.tintColor = Colors.skyBlue
//        paintColorButton.layer.cornerRadius = paintColorButton.frame.height * 0.5
//        paintColorButton.clipsToBounds = true

        eraserButton.tintColor = Colors.skyBlue
//        eraserButton.layer.cornerRadius = eraserButton.frame.height * 0.5
//        eraserButton.clipsToBounds = true
    }

    func setUpColorSlider() {
        colorSlider.minimumValue = 0
        colorSlider.maximumValue = 1
        colorSlider.value = 0.85
        colorSlider.isContinuous = false

        colorSlider.maximumTrackTintColor = UIColor.clear
        colorSlider.minimumTrackTintColor = UIColor.clear
//        sliderRatio = CGFloat(colorSlider.value / colorSlider.maximumValue)
    }

    func setUpSliderView(_ pickedColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = sliderView.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.white.cgColor, pickedColor.cgColor, UIColor.black.cgColor]
        self.sliderView.layer.addSublayer(gradient)

        sliderView.layer.cornerRadius = 5.0
        sliderView.clipsToBounds = true
    }

    @objc func onSliderChange(sender: UISlider) {
//        let value = CGFloat(sender.value)
//        adjustColor = self.adjustColor(pickedColor, value)
        let alpha = CGFloat(colorSlider.value / colorSlider.maximumValue)
        pickedColor = pickedColor.withAlphaComponent(alpha)

//        let tgl = CAGradientLayer()
//        let frame = CGRect(x: 0, y: 0, width: colorSlider.frame.size.width, height: 15)
//        tgl.frame = frame
//        tgl.startPoint = CGPoint(x: 0.0, y: 0.5)
//        tgl.endPoint = CGPoint(x: 1.0, y: 0.5)
//
////        tgl.colors = brightnessColors
//        tgl.colors = [UIColor.white.cgColor, pickedColor.cgColor]
//        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, tgl.isOpaque, 0.0)
//        tgl.render(in: UIGraphicsGetCurrentContext()!)
//        let brightnessImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        brightnessImage?.resizableImage(withCapInsets: UIEdgeInsets.zero)
//        colorSlider.setMinimumTrackImage(brightnessImage, for: [])
//
////        tgl.colors = darknessColors
//        tgl.colors = [pickedColor.cgColor, UIColor.black.cgColor]
//        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, tgl.isOpaque, 0.0)
//        tgl.render(in: UIGraphicsGetCurrentContext()!)
//        let darknessImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        darknessImage?.resizableImage(withCapInsets: UIEdgeInsets.zero)
//        colorSlider.setMaximumTrackImage(darknessImage, for: [])

    }

//    func adjustColor(_ color: UIColor, _ ratio: CGFloat) -> UIColor {
//
//        var saturation: CGFloat = 0.0
//        var brightness: CGFloat = 0.0
//        var hue: CGFloat = 0.0
//        var alpha: CGFloat = 0.0
//
//        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
//
//        let adjustColor = UIColor(hue: hue, saturation: saturation, brightness: ratio, alpha: alpha)
//
//        return adjustColor
//    }

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
            context?.setStrokeColor(pickedColor.cgColor)
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
