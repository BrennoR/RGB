//
//  ViewController.swift
//  RGB
//
//  Created by Brenno Ribeiro on 9/1/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import CoreLocation

var RH = [Float]()
var GH = [Float]()
var BH = [Float]()
var IH = [Float]()

enum flashState {
    case on
    case off
}

enum modeState {
    case Phosphate
    case Nitrate
    case pH
}

class CameraVC: UIViewController, CLLocationManagerDelegate {
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let locationManager = CLLocationManager()
    
    var photoData: Data?
    
    var flashControlState: flashState = .off
    var mode: modeState = .Phosphate
    
    var lvl = 0
    
    var latitude = "-"
    var longitude = "-"

    // IB Outlets
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var dash: UIView!
    @IBOutlet weak var sizingLbl: UILabel!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var rgbLbl: UILabel!
    @IBOutlet weak var shapeSelector: UIButton!
    @IBOutlet weak var shapeView: RoundedShadowView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var modeBtn: UIButton!
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var advancedStatsBtn: UIButton!
    @IBOutlet weak var dataBtn: RoundedShadowButton!
    
    
    // Mode Btns
    @IBOutlet weak var phosphateBtn: UIButton!
    @IBOutlet weak var nitrateBtn: UIButton!
    @IBOutlet weak var pHBtn: UIButton!
    
    // Constraint Outlets
    @IBOutlet weak var dashHeight: NSLayoutConstraint!
    @IBOutlet weak var shapeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var flashBtnY: NSLayoutConstraint!
    @IBOutlet weak var modeViewHeight: NSLayoutConstraint!
    
    let shapeLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()
    var shapeStatus = "square"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.cameraView.frame.size.width
        let height = self.cameraView.frame.size.height
        let trueWidthCenter = ceil(cameraView.frame.origin.x + width / 2)
        print(trueWidthCenter)
        let trueHeightCenter = ceil(cameraView.frame.origin.y + height / 2)
        print(trueHeightCenter)
        let boxWidth = CGFloat(140)
        let boxHeight = CGFloat(140)
        let heightPos = height / 2 - boxHeight / 2
        shapeViewWidth.constant = 0
        modeViewHeight.constant = 0
        phosphateBtn.isHidden = true
        nitrateBtn.isHidden = true
        pHBtn.isHidden = true
        advancedStatsBtn.isHidden = true
        
        shapeLayer.bounds = CGRect(x: 0, y:0, width: boxWidth, height: boxHeight)
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.path = UIBezierPath(rect: shapeLayer.bounds).cgPath
        shapeLayer.position = CGPoint(x: trueWidthCenter, y: trueHeightCenter)
        self.view.layer.addSublayer(shapeLayer)
        sizingLbl.frame.origin.x = shapeLayer.frame.origin.x
        sizingLbl.frame.origin.y = heightPos
        sizingLbl.frame.size = shapeLayer.frame.size
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: trueWidthCenter,y: trueHeightCenter), radius: CGFloat(70), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        circleLayer.path = circlePath.cgPath
        
        // change the fill color
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 1
        
        view.layer.addSublayer(circleLayer)
        circleLayer.isHidden = true
        
        modeBtn.setTitle(" Mode: \(mode)", for: .normal)
        modeBtn.backgroundColor = #colorLiteral(red: 0.3452148438, green: 0.8467610677, blue: 1, alpha: 0.4574593322)
        
        // location
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        updateWeather()
        
        _ =  Timer.scheduledTimer(timeInterval: 120.0, target: self, selector: #selector(updateWeather), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        tap.numberOfTapsRequired = 1
        
        let zoom = UIPinchGestureRecognizer(target:self, action: #selector(pinch))
        
        captureSession = AVCaptureSession()
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        if (backCamera?.isFocusModeSupported(.continuousAutoFocus))! {
            try! backCamera!.lockForConfiguration()
            backCamera!.focusMode = .continuousAutoFocus
            print("Focusing")
            backCamera!.unlockForConfiguration()
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }
            
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(cameraOutput) == true {
                captureSession.addOutput(cameraOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraView.layer.addSublayer(previewLayer!)
                cameraView.addGestureRecognizer(tap)
                cameraView.addGestureRecognizer(zoom)
                captureSession.startRunning()
            }
        } catch {
            debugPrint(error)
        }
    }
    
    @objc func didTapCameraView() {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String: 160]
        
        settings.previewPhotoFormat = previewFormat
        
        if flashControlState == .off {
            settings.flashMode = .off
        } else {
            settings.flashMode = .on
        }
        
        advancedStatsBtn.isHidden = false
        dashHeight.constant = 180 // Default: 150
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds
    }
    
    
    func analyzeRGB(box: UILabel) {
        switch shapeStatus {
        case "square":
            let RGB = captureImageView.image?.getAvgPixelColorFromBox(box: box)
            RGBValuesSetup(RGB: RGB!)
        case "circle":
            let RGB = captureImageView.image?.getAvgPixelColorFromCircle(box: box)
            RGBValuesSetup(RGB: RGB!)
        default:
            break
        }
    }
    
    func RGBValuesSetup(RGB: RGBValues) {
        switch mode {
        case .Phosphate:
            lvl = phosphateLvl(blue: RGB.blue)
        case .Nitrate:
            lvl = nitrateLvl(red: RGB.red)
        case .pH:
            lvl = pHLvl(green: RGB.green)
        }
        rgbLbl.text = "Red: \(RGB.red) \nGreen: \(RGB.green) \nBlue: \(RGB.blue) \nIntensity \(0.299*RGB.red + 0.587*RGB.green + 0.114*RGB.blue)\n\(mode): \(lvl) ppm"
        RH = (RGB.rh)
        GH = (RGB.gh)
        BH = (RGB.bh)
        IH = (RGB.ih)
        
        if let locValue: CLLocationCoordinate2D = self.locationManager.location?.coordinate {
            latitude = String(format: "%.3f", locValue.latitude)
            longitude = String(format: "%.3f", locValue.longitude)
        } else {
            latitude = "-"
            longitude = "-"
        }
        
        let temperature = currentTemperature
        let humidity = currentHumidity
        storeRGBData(date: Date(), location: latitude + ", " + longitude, chemical: "\(mode)", concentration: lvl, temperature: temperature, humidity: humidity)
    }
    
    func newMode(newMode: modeState, color: UIColor) {
        modeViewHeight.constant = 0
        phosphateBtn.isHidden = true
        nitrateBtn.isHidden = true
        pHBtn.isHidden = true
        mode = newMode
        modeBtn.backgroundColor = color
        modeBtn.setTitle(" Mode: \(mode)", for: .normal)
    }
    
    var selectorState = 0
    
    @IBAction func shapeSelectorBtnWasPressed(_ sender: Any) {
        if selectorState == 0 {
            shapeViewWidth.constant = 60
            flashBtnY.constant = shapeView.frame.height + 15
            selectorState = 1
        }
        else {
            shapeViewWidth.constant = 0
            flashBtnY.constant = 10
            selectorState = 0
        }
    }
    
    @IBAction func squareBtnWasPressed(_ sender: Any) {
        shapeChange(shape: "square")
        selectorState = 0
    }
    
    
    @IBAction func circleBtnWasPressed(_ sender: Any) {
        shapeChange(shape: "circle")
        selectorState = 0
    }
    
    func shapeChange(shape: String) {
        shapeSelector.setImage(UIImage(named: "shapeSelector-\(shape)"), for: .normal)
        if shape == "circle" {
            self.shapeLayer.isHidden = true
            self.circleLayer.isHidden = false
        } else {
            self.shapeLayer.isHidden = false
            self.circleLayer.isHidden = true
        }
        shapeViewWidth.constant = 0
        flashBtnY.constant = 10
        shapeStatus = shape
    }
    
    @IBAction func flashBtnWasPressed(_ sender: Any) {
        switch flashControlState {
        case .off:
            flashBtn.setImage(UIImage(named: "flashOn"), for: .normal)
            flashControlState = .on
        case .on:
            flashBtn.setImage(UIImage(named: "flashOff"), for: .normal)
            flashControlState = .off
        }
    }
    
    @IBAction func modeBtnWasPressed(_ sender: Any) {
        modeViewHeight.constant = 150
        phosphateBtn.isHidden = false
        nitrateBtn.isHidden = false
        pHBtn.isHidden = false
    }
    
    @IBAction func phosphateBtnWasPressed(_ sender: Any) {
        newMode(newMode: .Phosphate, color: #colorLiteral(red: 0.3452148438, green: 0.8467610677, blue: 1, alpha: 0.4574593322))
    }
    
    @IBAction func nitrateBtnWasPressed(_ sender: Any) {
        newMode(newMode: .Nitrate, color: #colorLiteral(red: 0.9204101563, green: 0.5655110677, blue: 1, alpha: 0.4574593322))
    }
    
    @IBAction func pHBtnWasPressed(_ sender: Any) {
        newMode(newMode: .pH, color: #colorLiteral(red: 0.3894585504, green: 0.8467610677, blue: 0.335015191, alpha: 0.4574593322))
    }
    
    @IBAction func advancedStatsBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "advancedStatsSegue", sender: nil)
    }
    
    @IBAction func dataBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "dataSegue", sender: nil)
    }
    
    
    
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    func storeRGBData(date: Date, location: String, chemical: String, concentration: Int, temperature: String, humidity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newData = NSEntityDescription.insertNewObject(forEntityName: "RGB_Data", into: context)
        newData.setValue(date, forKey: "date")
        newData.setValue(location, forKey: "location")
        newData.setValue(chemical, forKey: "chemical")
        newData.setValue(concentration, forKey: "concentration")
        newData.setValue(temperature, forKey: "temperature")
        newData.setValue(humidity, forKey: "humidity")

        do {
            try context.save()
            print("SAVED")
        } catch
        {
            print("ERROR")
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    // Weather data timer
    
    @objc func updateWeather()
    {
        if let locValue: CLLocationCoordinate2D = self.locationManager.location?.coordinate {
            let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(locValue.latitude)&lon=\(locValue.longitude)"
            WeatherService().getWeatherData(urlString: urlString)
//            print("WEATHER UPDATED")
        }
    }

}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            photoData = photo.fileDataRepresentation()
            
            let image = UIImage(data: photoData!)
            self.captureImageView.image = image
            analyzeRGB(box: sizingLbl)
            
            func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage? {
                var rect = rect
                print("scale: \(image.scale)")
                rect.size.width = rect.width * image.scale
                rect.size.height = rect.height * image.scale
                print("rect width: \(rect.width)")
                print("rect height: \(rect.height)")
                print("rect x: \(rect.minX) \(rect.maxX)")
                guard let imageRef = image.cgImage?.cropping(to: rect) else {
                    return nil
                }
                
                let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
                let contextSize: CGSize = contextImage.size
                print(contextSize.height)
                print(contextSize.width)
                
                let croppedImage = UIImage(cgImage:imageRef, scale: image.scale, orientation: image.imageOrientation)
                return croppedImage
            }
            
            func cropBottomImage(image: UIImage) -> UIImage {
//                let rect = CGRect(x: 750, y: 350, width: 400, height: 400)
                print(self.view.frame.width)
                print(self.view.frame.height)
                let rect = CGRect(x: self.view.frame.height + 70, y: self.view.frame.width - 70, width: 420, height: 420)
                return cropImage(image: image, toRect: rect)!
            }
            
            let newImg = cropBottomImage(image: image!)
            self.previewImageView.image = newImg
        }
    }
}

