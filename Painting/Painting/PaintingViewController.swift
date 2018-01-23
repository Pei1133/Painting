//
//  PaintingViewController.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/14.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit
import PocketSVG
import Crashlytics
import Sharaku
import SVProgressHUD

class PaintingViewController: UIViewController, UIScrollViewDelegate, ColorDelegate, CustomImageViewTouchEventDelegate {

    var url: URL?
    let provider = PathProvider()
    var paths = [SVGBezierPath]()
    var scrollView = UIScrollView()
    var pictureView = UIView()
    var imageView = CustomImageView()
    var pictureSize = CGSize.zero
    var pathCount = 0

    var isFill: Bool = true
    var redoLayers: [CAShapeLayer] = []
    var lastPoint = CGPoint.zero
    var swiped = false

    // MARK: - color button
    @IBOutlet weak var paintingView: UIView!
    @IBOutlet weak var color0: ColorButton!
    @IBOutlet weak var color1: ColorButton!
    @IBOutlet weak var color2: ColorButton!
    @IBOutlet weak var color3: ColorButton!
    @IBOutlet weak var color4: ColorButton!

    @IBAction func tapColor(_ sender: ColorButton) {

        pickedColor = sender.backgroundColor!
//        var saturation: CGFloat = 0.0
//        var brightness: CGFloat = 0.0
//        var hue: CGFloat = 0.0
//        var alpha: CGFloat = 0.0
//
//        let selectedColor = sender.backgroundColor!
//        if selectedColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
//
//            self.pickedColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: alpha)
//        }
    }

    // MARK: - colorSlider
    var sliderPercentage: CGFloat = 0.5
    @IBOutlet weak var colorSlider: ColorSlider!
    @IBOutlet weak var sliderView: UIView!
    @IBAction func tapColorSlider(_ sender: ColorSlider) {

        let percentage = CGFloat(colorSlider.value / colorSlider.maximumValue)
        self.sliderPercentage = percentage

        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var hue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if self.pickedColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {

            if percentage >= 0.5 {

                self.sliderColor = UIColor(hue: hue, saturation: 1, brightness: 1 - ( 2 * percentage - 1), alpha: alpha)
            }else {

                self.sliderColor = UIColor(hue: hue, saturation: 2 * percentage, brightness: 1, alpha: alpha)
            }
        }else {
            print("sliderColor error")
        }
    }

    // MARK: - colorPicker
    @IBOutlet private(set) weak var colorPicker: ColorPicker!

    func pickedColor(color: UIColor) {
        self.pickedColor = color
    }

    var pickedColor = Colors.lightSkyBlue {
        didSet {
            setUpSliderView(pickedColor)
            colorSlider.value = 0.5
            self.sliderColor = pickedColor
            print("aaa,\(pickedColor)")
        }
    }
    var sliderColor = Colors.lightSkyBlue {
        didSet {
            colorSlider.thumbTintColor = sliderColor
        }
    }
    func saveToSelectedColors() {

        if sliderColor != color0.backgroundColor && sliderColor != color1.backgroundColor && sliderColor != color2.backgroundColor && sliderColor != color3.backgroundColor && sliderColor != color4.backgroundColor {
                color4.backgroundColor = color3.backgroundColor
                color3.backgroundColor = color2.backgroundColor
                color2.backgroundColor = color1.backgroundColor
                color1.backgroundColor = color0.backgroundColor
                color0.backgroundColor = sliderColor
        }
    }

//    @IBAction func tapSave(_ sender: Any) {
//
//        UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
//    }

    override func viewDidLoad() {

        super.viewDidLoad()

        colorPicker.delegate = self

        if let url = url {
            let paths = SVGBezierPath.pathsFromSVG(at: url)
            self.paths = paths

            let renderParameter = provider.renderPaths(url: url, imageView: imageView)
            self.imageView = renderParameter.imageView
            self.pictureSize = renderParameter.pictureSize
            self.pathCount = renderParameter.pathCount
            SVProgressHUD.dismiss()
        }else {
            print("no URL")
            isFill = false
            self.pictureSize = CGSize(width: view.bounds.width, height: view.bounds.height - 200)
        }

        setUpNavigationBar()
        setUpScrollViewAndImageView()
        setUpColorPicker()
        setUpButton()
        setUpColorSlider()
        setUpSliderView(pickedColor)
//        showSVG()

     // Step1 :- Initialize Tap Event on view where your UIBeizerPath Added.
        // Catch layer by tap detection
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaintingViewController.tapDetected(tapRecognizer:)))
        self.imageView.addGestureRecognizer(tapRecognizer)

    }

    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.showInfo(withStatus: "Loading")
    }

    func showSVG() {
        let svgImageView = SVGImageView.init(contentsOf: url!)
        svgImageView.frame = self.view.bounds
        view.addSubview(svgImageView)
    }

    // MARK: - Fill Color
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

                    saveToSelectedColors()

                    // undoButton appear
                    self.navigationItem.leftBarButtonItems![1].tintColor = Colors.deepCyanBlue.withAlphaComponent(1)

                    // redoButton disappear
                    self.navigationItem.rightBarButtonItems![1].tintColor = Colors.deepCyanBlue.withAlphaComponent(0.3)

                    redoLayers = []

                    return
                }
            }
        }
    }

    @objc func tapUndoFill(_ sender: Any) {

        guard let sublayers = self.imageView.layer.sublayers else {return}
        if sublayers.count > pathCount {

            // redoButton appear
            self.navigationItem.rightBarButtonItems![1].tintColor = Colors.deepCyanBlue.withAlphaComponent(1)

            guard let removeLastLayer = self.imageView.layer.sublayers?.last as? CAShapeLayer else {return}
            redoLayers.append(removeLastLayer)
            self.imageView.layer.sublayers?.removeLast()
        }

        // afterRemoveSublayers & undoButton disappear
        guard let afterRemoveSublayers = self.imageView.layer.sublayers else {return}
        if afterRemoveSublayers.count <= pathCount {
            self.navigationItem.leftBarButtonItems![1].tintColor = Colors.deepCyanBlue.withAlphaComponent(0.3)
        }

    }

    @objc func tapRedoFill(_ sender: Any) {

        guard let sublayers = self.imageView.layer.sublayers else {return}
        if sublayers.count > pathCount {

            // undoButton appear
            self.navigationItem.leftBarButtonItems![1].tintColor = Colors.deepCyanBlue.withAlphaComponent(1)
        }

        let redoCount = redoLayers.count
        if redoCount > 0 {
            self.imageView.layer.addSublayer(redoLayers[redoCount - 1])
            redoLayers.remove(at: redoCount - 1)

            // redoButton disappear
            if redoCount - 1 == 0 {
                self.navigationItem.rightBarButtonItems![1].tintColor = Colors.deepCyanBlue.withAlphaComponent(0.3)
            }
        }
    }

    // MARK: - Set up

    func setUpNavigationBar() {
        // title
//        let localTitle = NSLocalizedString("Color Your Own", comment: "")
//        self.navigationItem.title = localTitle
        self.navigationItem.title = "ColorLife"
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        let font = UIFont(name: "BradleyHandITCTT-Bold", size: 25)
        let textAttributes = [
            NSAttributedStringKey.font: font ?? UIFont.systemFont(ofSize: 25),
            NSAttributedStringKey.foregroundColor: Colors.deepCyanBlue
        ]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes

        // left button
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(goBack))
        let undoButton = UIBarButtonItem(image: #imageLiteral(resourceName: "undo1"), style: .plain, target: self, action: #selector(tapUndoFill))
        leftButton.tintColor = Colors.deepCyanBlue
        undoButton.tintColor = Colors.deepCyanBlue.withAlphaComponent(0.3)
        self.navigationItem.leftBarButtonItems = [leftButton, undoButton]

        // right button
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share1"), style: .plain, target: self, action: #selector(share))
        let redoButton = UIBarButtonItem(image: #imageLiteral(resourceName: "redo1"), style: .plain, target: self, action: #selector(tapRedoFill))
        rightButton.tintColor = Colors.deepCyanBlue
        redoButton.tintColor = Colors.deepCyanBlue.withAlphaComponent(0.3)
        self.navigationItem.rightBarButtonItems = [rightButton, redoButton]

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
        navigationController?.navigationBar.layer.shadowColor = UIColor(red: 93.0 / 255.0, green: 151.0 / 255.0, blue: 175.0 / 255.0, alpha: 0.85).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 4

        // hide bottom line
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setUpColorPicker() {

        colorPicker.layer.cornerRadius = 5.0
        colorPicker.clipsToBounds = true
    }

    func setUpButton() {

        color0.backgroundColor = Colors.orange
        color1.backgroundColor = Colors.yellow
        color2.backgroundColor = Colors.green
        color3.backgroundColor = Colors.lightSkyBlue
        color4.backgroundColor = Colors.darkBlue
    }

    func setUpColorSlider() {

        colorSlider.minimumValue = 0.0
        colorSlider.maximumValue = 1.0
        colorSlider.value = 0.5
        colorSlider.isContinuous = true
        colorSlider.thumbTintColor = Colors.lightSkyBlue

        colorSlider.maximumTrackTintColor = UIColor.clear
        colorSlider.minimumTrackTintColor = UIColor.clear
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
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.7))

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

    // MARK: - ScrollView

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    // MARK: - Transform
    //讓layer轉型成UIImage
    func layerTransImage(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)

        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    // MARK: - goBack
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Share
    @objc func share(_ sender: Any) {

        let image = UIImage.init(view: imageView)

        let recalculateImage = resizeImage(image: image, targetSize: CGSize(width: 1000, height: 1000))

        // choose filter
        let filterController = SHViewController(image: recalculateImage)

        filterController.delegate = self

        self.present(filterController, animated: true, completion: nil)

    }

    // MARK: - Painting Color

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

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.1)

        view.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        let compressImageData = UIImageJPEGRepresentation(image!, 1)

        self.init(data: compressImageData!)!

    }
}

extension PaintingViewController: SHViewControllerDelegate {

    func shViewControllerImageDidFilter(image: UIImage) {
        // Filtered image will be returned here.

        // filterController dismiss
        dismiss(animated: true, completion: nil)

        // ShareController appear
        let imageToShare = [image]

        if !imageToShare.isEmpty {

            let shareViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)

            self.present(shareViewController, animated: true, completion: nil)
        }
    }

    func shViewControllerDidCancel() {
        // This will be called when you cancel filtering the image.
    }
}
