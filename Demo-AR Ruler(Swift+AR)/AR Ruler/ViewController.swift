//
//  ViewController.swift
//  AR Ruler
//
//  Created by Giorgi Shukakidze on 4/6/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count == 2 {
            dotNodes.first?.removeFromParentNode()
            dotNodes.removeFirst()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitResults.first {
                addDot(at: hitResult)
            }
        }
    }
    // MARK: - Measure Functions
    
    func addDot(at hitResult: ARHitTestResult){
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [dotMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z
        )
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculateDistance()
        }
    }
    
    func calculateDistance() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        
        updateText(text: "\(abs(distance))", at: start.position)
    }
    
    func updateText(text: String, at position: SCNVector3) {
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y + 0.1, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
