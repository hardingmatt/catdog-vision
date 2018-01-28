//
//  Scene.swift
//  AR-CatDog-Vision
//
//  Created by Matthew Harding on 1/28/18.
//  Copyright © 2018 Matt Harding. All rights reserved.
//

import SpriteKit
import ARKit
import Vision

class Scene: SKScene {

//    let ghostsLabel = SKLabelNode(text: "Ghosts")
//    let numberOfGhostsLabel = SKLabelNode(text: "0")
//    var creationTime : TimeInterval = 0
//    var ghostCount = 0 {
//        didSet {
//            self.numberOfGhostsLabel.text = "\(ghostCount)"
//        }
//    }

    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        print(".")
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        print("Touch")

        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            DispatchQueue.global(qos: .background).async {
                do {
                    let model = try VNCoreMLModel(for: BetterCatDogImageClassifier().model)
                    let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                        // Jump onto the main thread
                        DispatchQueue.main.async {
                            // Access the first result in the array after casting the array as a VNClassificationObservation array
                            guard let results = request.results as? [VNClassificationObservation], let result = results.first else {
                                print ("No results?")
                                return
                            }

                            // Create a transform with a translation of "z" meters in front of the camera
                            var translation = matrix_identity_float4x4
                            translation.columns.3.z = -0.1
                            let transform = simd_mul(currentFrame.camera.transform, translation)

                            // Add a new anchor to the session
                            let anchor = ARAnchor(transform: transform)

                            // Set the identifier
                            ARBridge.shared.anchorsToIdentifiers[anchor] = result.identifier
                            print(result)

                            sceneView.session.add(anchor: anchor)
                        }
                    })

                    let handler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage, options: [:])
                    try handler.perform([request])
                } catch {}
            }
        }

    }
}
