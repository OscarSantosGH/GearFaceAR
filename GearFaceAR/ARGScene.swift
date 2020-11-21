//
//  ARGScene.swift
//  GearFaceAR
//
//  Created by Oscar Santos on 11/19/20.
//

import Foundation
import UIKit
import SceneKit
import ARKit

typealias ARGSceneRenderUpdateAtTimeHandler = (SCNSceneRenderer, TimeInterval) -> Void
typealias ARGSceneRenderDidRenderSceneHandler = (SCNSceneRenderer, SCNScene, TimeInterval) -> Void

typealias ARGSceneSessionDidUpdateFrameHandler = (ARSession, ARFrame) -> Void

class ARGScene: NSObject {
    
    var sceneRenderUpdateAtTimeHandler: ARGSceneRenderUpdateAtTimeHandler?
    var sceneRenderDidRenderSceneHandler: ARGSceneRenderDidRenderSceneHandler?
    var sceneSessionDidUpdateFrameHandler: ARGSceneSessionDidUpdateFrameHandler?
    
    lazy var sceneView = ARSCNView()
    
    var objectNodes: [SCNNode] = []
    
    init(viewContainer: UIView?){
        super.init()
        
        let scene = SCNScene()

        // setup preview
        if let viewContainer = viewContainer {
            sceneView.scene = scene
            sceneView.frame = viewContainer.bounds
            sceneView.delegate = self
            sceneView.session.delegate = self
            sceneView.showsStatistics = false
            sceneView.rendersContinuously = true
            sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sceneView.backgroundColor = .clear
            sceneView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            sceneView.isUserInteractionEnabled = true
            
        }
        
        self.setupSession()
    }
    
    func setupSession() {
        
        let arkitFaceTrackingConfig = ARFaceTrackingConfiguration()
        sceneView.session.run(arkitFaceTrackingConfig, options: [.removeExistingAnchors, .resetTracking])
    }
    
}

extension ARGScene: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard let handler = sceneRenderUpdateAtTimeHandler
            else { return }
        
        handler(renderer, time)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let handler = sceneRenderDidRenderSceneHandler
            else { return }
        
        handler(renderer, scene, time)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
   }
}

extension ARGScene: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        guard let handler = sceneSessionDidUpdateFrameHandler
            else { return }
        
        handler(session, frame)
    }
}
