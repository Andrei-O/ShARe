//
//  ARViewController.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 16/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import UIKit
import ARKit
import MultipeerConnectivity

class ARViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    
    //MARK: - Properties
    private var multipeerSession: MultipeerSession!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerSession = MultipeerSession(receivedDataHandler: handleReceivedPeerData)
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupARSceneConfiguration()
        toggleIdleTimer(enabled: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        toggleIdleTimer(enabled: false)
    }
    
    //MARK: - Setup
    private func setupUI() {
        
    }
    
    private func setupARSceneConfiguration() {
        guard ARWorldTrackingConfiguration.isSupported else { fatalError(LocalizedStrings.ARScreen.arFrameworkNotSupported) }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        #if DEBUG
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        #endif
    }
    
    private func toggleIdleTimer(enabled: Bool) {
        UIApplication.shared.isIdleTimerDisabled = enabled
    }
    
    //MARK: - Actions
    
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touchPoint, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
        guard let firstHitTestResult = hitTestResults.first else { return }
        
        let anchor = ARAnchor(name: "plant", transform: firstHitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
        
        //notify connected peers about the object that we just placed in the scene
    }
    
    
    //MARK: - Helper functions
    private func handleReceivedPeerData(data: Data, peerID: MCPeerID) {
        print("Received data from peer: \(peerID.displayName)")
    }
    
    private func loadObject() -> SCNNode? {
        return SCNNode(name: ARSceneConstants.VirtualObjects.resourceName)
    }
}

//MARK: - Delegates

extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // load new object
        guard let anchorName = anchor.name,
            anchorName.hasPrefix("plant"),
            let objectNode = loadObject() else { return }
        node.addChildNode(objectNode)
    }
}

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
    }
}
