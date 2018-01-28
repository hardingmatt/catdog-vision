//
//  ViewController.swift
//  AR-CatDog-Vision
//
//  Created by Matthew Harding on 1/28/18.
//  Copyright © 2018 Matt Harding. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        let scene = Scene(size: self.view.frame.size)
        sceneView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
//    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
//        // Create and configure a node for the anchor added to the view's session.
//        let labelNode = SKLabelNode(text: "👾")
//        labelNode.horizontalAlignmentMode = .center
//        labelNode.verticalAlignmentMode = .center
//        return labelNode;
//    }

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        guard let identifier = ARBridge.shared.anchorsToIdentifiers[anchor] else {
            return nil
        }
        let emoji:String
        if identifier == "cat" {
            emoji = "😺"
        } else if identifier == "dog" {
            emoji = "🐶"
        } else {
            emoji = "?"
        }

        let labelNode = SKLabelNode(text: emoji)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.fontName = UIFont.boldSystemFont(ofSize: 1).fontName
        labelNode.fontColor = UIColor.black
        return labelNode
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
