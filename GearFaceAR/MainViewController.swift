//
//  ViewController.swift
//  GearFaceAR
//
//  Created by Oscar Santos on 11/18/20.
//

import UIKit
import AVFoundation
import ARGear

let API_HOST = "https://apis.argear.io/api/v3/"
let API_KEY = "2f7b45e1314ef1d07abb3959"
let API_SECRET_KEY = "2986ecc1ee2ffadc6927a382674d8ab40d44c79da45aab8cc9326590295448f5"
let API_AUTH_KEY = "U2FsdGVkX1+h5jjopWLhGL0SysmPHFpPAmpNHZAdwJL3f1NqnAeiMQRa/xAHq5x0"

class MainViewController: UIViewController {
    
    var argSession: ARGSession?
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var consoleLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startARSessions()
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        argSession?.run()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            consoleLabel.text = "preview layer failed"
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    func startARSessions(){
        do {
            let config = ARGConfig(
                apiURL: API_HOST,
                apiKey: API_KEY,
                secretKey: API_SECRET_KEY,
                authKey: API_AUTH_KEY
            )
            argSession = try ARGSession(argConfig: config, feature: [.faceLowTracking])
            argSession?.delegate = self
        }
        catch let error as NSError {
            print(error)
        }
        catch let exception as NSException {
            print(exception)
        }
    }
    
    
    
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) else {
            consoleLabel.text = "VideoCapture Failed"
            return
        }
        
        
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            consoleLabel.text = "VideoInput Failed"
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            consoleLabel.text = "captureSession addInput Failed"
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        } else {
            consoleLabel.text = "Invalid Input"
            return
        }
        
        let captureData = AVCaptureVideoDataOutput()
        
        if captureSession.canAddOutput(captureData) {
            captureSession.addOutput(captureData)
            captureData.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        } else {
            consoleLabel.text = "Invalid Input"
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        cameraView.layer.addSublayer(previewLayer!)
        
    }
    
    
    
    @IBAction func runSession(_ sender: Any) {
        //argSession?.run()
    }
    
    @IBAction func beautyAction(_ sender: Any) {
        guard let session = argSession, let contents = session.contents else {
            return
        }
        //contents.setBulge(.NONE)
        //contents.setDefaultBeauty()
        consoleLabel.text = "Beauty ON"
        
        // Set a Specific Face Beautification Effect Level
            contents.setBeauty(.faceSlim, value: 0.9)
                
            // Set 16 Face Beautification Effects at the Same Time
//            var beautyValue: [Float] = [
//                10.0,
//                90.0,
//                55.0,
//                -50.0,
//                5.0,
//                -10.0,
//                0.0,
//                35.0,
//                30.0,
//                -35.0,
//                0.0,
//                0.0,
//                0.0,
//                50.0,
//                0.0,
//                0.0
//            ]
//
//            let beautyValuePointer: UnsafeMutablePointer<Float> = UnsafeMutablePointer(&beautyValue)
//            contents.setBeautyValues(beautyValuePointer)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        if let session = argSession, let contents = session.contents {
            contents.setBulge(.FUN6)
        }
    }
    
}

extension MainViewController: ARGSessionDelegate{
    func didUpdate(_ frame: ARGFrame) {
        guard let pixelBuffer = frame.renderedPixelBuffer else {
            return
        }
        // draw sublayer(CALayer())'s contents
        //self.previewLayer!.contents = renderedPixelbuffer
        
        DispatchQueue.main.async {
        
            var flipTransform = CGAffineTransform(scaleX: 1, y: 1)

            CATransaction.flush()
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            self.previewLayer!.contents = pixelBuffer
            let angleTransform = CGAffineTransform(rotationAngle: .pi/2)
            let transform = angleTransform.concatenating(flipTransform)
            self.previewLayer!.setAffineTransform(transform)
            self.previewLayer!.frame = CGRect(x: 0, y: 0, width: self.previewLayer!.frame.size.width, height: self.previewLayer!.frame.size.height)
            CATransaction.commit()
        }
        
    }
}

extension MainViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    // AVCaptureMetadataOutput Delegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //argSession?.update(metadataObjects, from: connection)
    }
}

extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // AVCaptureVideoDataOutput Delegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        argSession?.update(sampleBuffer, from: connection)
    }
}
