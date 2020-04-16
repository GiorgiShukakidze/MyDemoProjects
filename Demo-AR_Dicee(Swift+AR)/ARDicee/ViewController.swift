//
//  ViewController.swift
//  ARDicee
//
//  Created by Giorgi Shukakidze on 4/1/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func rollButtonPressed(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
            diceArray.removeAll()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                addDice(at: hitResult)
            }
        }
    }
    
    
    // MARK: - ARSCNViewDelegate
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//
//        let planeNode = createPlane(with: planeAnchor)
//        node.addChildNode(planeNode)
//
//    }
    
    //MARK: - Dice functions
    
    func addDice(at location: ARHitTestResult) {
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(
                x: location.worldTransform.columns.3.x,
                y: location.worldTransform.columns.3.y,
                z: location.worldTransform.columns.3.z
            )
            
            diceArray.append(diceNode)
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(diceNode)
        }
    }
    
    func rollAll() {
        
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice)
            }
        }
    }
    
    func roll(_ dice: SCNNode) {
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(
            SCNAction.rotateBy(
                x: CGFloat(randomX * 3),
                y: 0,
                z: CGFloat(randomZ * 3),
                duration: 0.5
            )
        )
    }
    
    //MARK: - Plane rendering methods
    
//    func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode {
//        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//
//        let planeNode = SCNNode()
//        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//
//        let gridMaterial = SCNMaterial()
//        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
//
//        plane.materials = [gridMaterial]
//
//        planeNode.geometry = plane
//
//        return planeNode
//    }
}
