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
    
    init(viewContainer: UIView?){
        super.init()
        
//        guard
//          let scene = SCNScene(named: "face.scn")
//        else {
//            fatalError("Failed to load face scene!")
//        }
        
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
            sceneView.isUserInteractionEnabled = false
            if #available(iOS 11.0, *) {
                sceneView.rendersContinuously = true
            }
            viewContainer.addSubview(sceneView)
        }
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
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//        guard let planeAnchor = anchor as? ARPlaneAnchor
//            else { return }
//
//        let plane = Plane(anchor: planeAnchor, in: sceneView)
//        node.addChildNode(plane)
//    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//
//        guard let planeAnchor = anchor as? ARPlaneAnchor,
//            let plane = node.childNodes.first as? Plane
//            else { return }
//
//        // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
//        if #available(iOS 11.3, *) {
//            if let planeGeometry = plane.meshNode.geometry as? ARSCNPlaneGeometry {
//                planeGeometry.update(from: planeAnchor.geometry)
//            }
//        }
//
//        // Update extent visualization to the anchor's new bounding rectangle.
//        if let extentGeometry = plane.extentNode.geometry as? SCNPlane {
//            extentGeometry.width = CGFloat(planeAnchor.extent.x)
//            extentGeometry.height = CGFloat(planeAnchor.extent.z)
//            plane.extentNode.simdPosition = planeAnchor.center
//        }
//    }
}

extension ARGScene: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        guard let handler = sceneSessionDidUpdateFrameHandler
            else { return }
        
        handler(session, frame)
    }
}
