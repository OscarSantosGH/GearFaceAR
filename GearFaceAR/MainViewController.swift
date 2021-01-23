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
    @IBOutlet weak var controlsContainer: UIView!
    @IBOutlet weak var sliderControl: UISlider!
    
    @IBOutlet weak var skinBtn: FilterButton!
    @IBOutlet weak var chinBtn: FilterButton!
    @IBOutlet weak var eyesBtn: FilterButton!
    @IBOutlet weak var circlesBtn: FilterButton!
    @IBOutlet weak var noseBtn: FilterButton!
    @IBOutlet weak var mouthBtn: FilterButton!
    
    var selectedFilter: FilterType!
    
    private var currentARKitFrame: ARFrame?

    override public func viewDidLoad() {
        super.viewDidLoad()
        startARSessions()
        setupScene()
        configureFilterButtons()
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
    
    func configureFilterButtons(){
        skinBtn.filterType = .skin
        chinBtn.filterType = .chin
        eyesBtn.filterType = .eyes
        circlesBtn.filterType = .circle
        noseBtn.filterType = .nose
        mouthBtn.filterType = .mouth
        
        skinBtn.isSelected = true
        selectedFilter = .skin
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
    
    //MARK: - Controls
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        switch selectedFilter {
        case .skin:
            skinBtn.filterValue = sender.value
            contents.setBeauty(.skinFace, value: sender.value)
        case .chin:
            chinBtn.filterValue = sender.value
            contents.setBeauty(.chin, value: sender.value)
        case .eyes:
            eyesBtn.filterValue = sender.value
            contents.setBeauty(.eye, value: sender.value)
        case .circle:
            circlesBtn.filterValue = sender.value
            contents.setBeauty(.skinDarkCircle, value: sender.value)
        case .nose:
            noseBtn.filterValue = sender.value
            contents.setBeauty(.noseSise, value: sender.value)
        case .mouth:
            mouthBtn.filterValue = sender.value
            contents.setBeauty(.mouthSize, value: sender.value)
        case .none: break
            
        }
        
    }
    
    @IBAction func resetFilter(_ sender: UIButton) {
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        sliderControl.value = 0.0
        
        switch selectedFilter {
        case .skin:
            skinBtn.filterValue = 0
            contents.setBeauty(.skinFace, value: 0)
        case .chin:
            chinBtn.filterValue = 0
            contents.setBeauty(.chin, value: 0)
        case .eyes:
            eyesBtn.filterValue = 0
            contents.setBeauty(.eye, value: 0)
        case .circle:
            circlesBtn.filterValue = 0
            contents.setBeauty(.skinDarkCircle, value: 0)
        case .nose:
            noseBtn.filterValue = 0
            contents.setBeauty(.noseSise, value: 0)
        case .mouth:
            mouthBtn.filterValue = 0
            contents.setBeauty(.mouthSize, value: 0)
        case .none: break
            
        }
    }
    
    @IBAction func selectFilterAction(_ sender: FilterButton) {
        skinBtn.isSelected = false
        chinBtn.isSelected = false
        eyesBtn.isSelected = false
        circlesBtn.isSelected = false
        noseBtn.isSelected = false
        mouthBtn.isSelected = false
        
        switch selectedFilter {
        case .skin, .circle, .nose:
            sliderControl.minimumValue = 0
            sliderControl.maximumValue = 100
        case .chin, .eyes, .mouth:
            sliderControl.minimumValue = -100
            sliderControl.maximumValue = 100
        case .none: break
            
        }
        
        sender.isSelected = true
        selectedFilter = sender.filterType
        sliderControl.value = sender.filterValue
    }
    
    
}

extension MainViewController: ARGSessionDelegate{
    func didUpdate(_ frame: ARGFrame) {
        drawARCameraPreview()
    }
}
