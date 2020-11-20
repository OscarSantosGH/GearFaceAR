//
//  ARGScene.swift
//  GearFaceAR
//
//  Created by Oscar Santos on 11/19/20.
//

import Foundation
import UIKit
import SceneKit

typealias ARGSceneRenderUpdateAtTimeHandler = (SCNSceneRenderer, TimeInterval) -> Void
typealias ARGSceneRenderDidRenderSceneHandler = (SCNSceneRenderer, SCNScene, TimeInterval) -> Void

class ARGScene: NSObject {
    
    var sceneRenderUpdateAtTimeHandler: ARGSceneRenderUpdateAtTimeHandler?
    var sceneRenderDidRenderSceneHandler: ARGSceneRenderDidRenderSceneHandler?
    
    lazy var sceneView = SCNView()
    lazy var sceneCamera = SCNCamera()
    
    init(viewContainer: UIView?){
        super.init()
        
        guard
          let scene = SCNScene(named: "Face.scnassets/face.scn")
        else {
            fatalError("Failed to load face scene!")
        }

        let cameraNode = SCNNode()
        cameraNode.camera = sceneCamera
        scene.rootNode.addChildNode(cameraNode)

        // setup preview
        if let viewContainer = viewContainer {
            sceneView.scene = scene
            sceneView.frame = viewContainer.bounds
            sceneView.delegate = self
            sceneView.showsStatistics = false
            sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sceneView.backgroundColor = .clear
            sceneView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            sceneView.isUserInteractionEnabled = false
            if #available(iOS 11.0, *) {
                sceneView.rendersContinuously = true
            }
            viewContainer.addSubview(sceneView)
        }
    }
}

extension ARGScene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard
            let handler = sceneRenderUpdateAtTimeHandler
            else {
            return
        }

        handler(renderer, time)
    }

    public func renderer( _ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard
            let handler = sceneRenderDidRenderSceneHandler
            else {
            return
        }

        handler(renderer, scene, time)
    }
}
