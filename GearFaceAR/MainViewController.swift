//
//  ViewController.swift
//  GearFaceAR
//
//  Created by Oscar Santos on 11/18/20.
//

import UIKit
import AVFoundation
import ARGearRenderer
import ARKit

class MainViewController: UIViewController {
    
    private var argConfig: ARGConfig?
    private var argSession: ARGSession?
    private var currentFaceFrame: ARGFrame?
    private var nextFaceFrame: ARGFrame?
    
    private lazy var cameraPreviewCALayer = CALayer()
    
    private var arScene: ARGScene!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var consoleLabel: UILabel!
    
    private var currentARKitFrame: ARFrame?
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        startARSessions()
        setupScene()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        argSession?.run()
        NetworkManager.shared.argSession = argSession
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        argSession?.pause()
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
            argSession?.inferenceDebugOption = .optionDebugFaceLandmark2D
        }
        catch let error as NSError {
            print(error)
        }
        catch let exception as NSException {
            print(exception)
        }
    }
    
    // MARK: - setupScene
    private func setupScene() {
        arScene = ARGScene(viewContainer: self.cameraView)

        arScene.sceneRenderUpdateAtTimeHandler = { [weak self] renderer, time in
            guard let _ = self else { return }
        }

        arScene.sceneRenderDidRenderSceneHandler = { [weak self] renderer, scene, time in
            guard let self = self else { return }
            
            guard let _ = self.arScene.sceneView.session.configuration as? ARWorldTrackingConfiguration else {
                return
            }
            
            self.drawARCameraPreview()
        }
        
        arScene.sceneSessionDidUpdateFrameHandler = { [weak self] session, frame in
            guard let self = self else { return }
            self.sessionDidUpdateFrame(session, didUpdate: frame)
        }

        cameraPreviewCALayer.contentsGravity = .resizeAspectFill
        cameraPreviewCALayer.frame = CGRect(x: 0, y: 0, width: arScene.sceneView.frame.size.height, height: arScene.sceneView.frame.size.width)
        cameraPreviewCALayer.contentsScale = UIScreen.main.scale
        cameraView.layer.insertSublayer(cameraPreviewCALayer, at: 0)
    }
    
    
    // MARK: ARGScene ARKit Session
    private func sessionDidUpdateFrame(_ session: ARSession, didUpdate frame: ARFrame) {
        
        self.currentARKitFrame = frame
        
        let viewportSize = arScene.sceneView.bounds.size
        var updateFaceAnchor: ARFaceAnchor? = nil
        var isFace = false
        if let faceAnchor = frame.anchors.first as? ARFaceAnchor {
            if faceAnchor.isTracked {
                updateFaceAnchor = faceAnchor
                isFace = true
            }
        } else {
            if let _ = frame.anchors.first as? ARPlaneAnchor {
                
            }
        }
        
        // convert handler (required)
        let handler: ARGSessionProjectPointHandler = { (transform: simd_float3, orientation: UIInterfaceOrientation, viewport: CGSize) in
            
            return frame.camera.projectPoint(transform, orientation: orientation, viewportSize: viewport)
        }
        
        if isFace {
            if let faceAnchor = updateFaceAnchor {
                self.argSession?.applyAdditionalFaceInfo(withPixelbuffer: frame.capturedImage, transform: faceAnchor.transform, vertices: faceAnchor.geometry.vertices, viewportSize: viewportSize, convert: handler)
            } else {
                self.argSession?.feedPixelbuffer(frame.capturedImage)
            }
        } else {
            self.argSession?.feedPixelbuffer(frame.capturedImage)
        }
    }
    
    // MARK: - ARGearSDK Handling
    private func drawARCameraPreview() {
        
        guard let config = self.arScene.sceneView.session.configuration else  {
            return
        }
        
        DispatchQueue.main.async {
        
            var pixelBuffer: CVPixelBuffer?
            var flipTransform = CGAffineTransform(scaleX: 1, y: 1)
            if config == ARFaceTrackingConfiguration() {
                if let frame = self.argSession?.frame, let buffer = frame.renderedPixelBuffer {
                    pixelBuffer = buffer
                }
                flipTransform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                if let frame = self.currentARKitFrame {
                    pixelBuffer = frame.capturedImage
                }
            }

            CATransaction.flush()
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            self.cameraPreviewCALayer.contents = pixelBuffer
            let angleTransform = CGAffineTransform(rotationAngle: .pi/2)
            let transform = angleTransform.concatenating(flipTransform)
            self.cameraPreviewCALayer.setAffineTransform(transform)
            self.cameraPreviewCALayer.frame = CGRect(x: 0, y: 0, width: self.cameraPreviewCALayer.frame.size.width, height: self.cameraPreviewCALayer.frame.size.height)
            CATransaction.commit()
        }
    }
    
    
    
    @IBAction func runSession(_ sender: Any) {
        //argSession?.run()
    }
    
    @IBAction func beautyAction(_ sender: UIButton) {
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        if sender.isSelected {
            contents.setBeautyOn(false)
        } else {
            contents.setBulge(.NONE)
            contents.setDefaultBeauty()
            
            // set beauty one value
    //        contents.setBeauty(.faceSlim, value: 0.7)
            
            // set all beauties
            let beautyValue: [Float] = [
                10.0,
                90.0,
                55.0,
                -50.0,
                5.0,
                -10.0,
                0.0,
                35.0,
                30.0,
                -35.0,
                0.0,
                0.0,
                0.0,
                50.0,
                0.0,
                0.0
            ]

            let beautyValuePointer = UnsafeMutablePointer<Float>.allocate(capacity: beautyValue.count)
            beautyValuePointer.assign(from: beautyValue, count: beautyValue.count)
            contents.setBeautyValues(beautyValuePointer)
            beautyValuePointer.deallocate()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        if sender.isSelected {
            contents.clear(.filter)
        } else {
            
            // filter download (first)
            NetworkManager.shared.downloadItem(url:"https://privatecontent.argear.io/contents/data/87942be0-f470-11e9-93ab-175806ecc470.zip", title:"azalea", type: "filter")
        }
        sender.isSelected = !sender.isSelected
    }
    
}

extension MainViewController: ARGSessionDelegate{
    func didUpdate(_ frame: ARGFrame) {
        drawARCameraPreview()
    }
}
