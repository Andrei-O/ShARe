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
//    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: - Properties
    private var multipeerSession: MultipeerSession!
    private var shareButtonViewController: ShareButtonViewController!
    private var peersCounterViewController: PeerCounterViewController!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerSession = MultipeerSession(receivedDataHandler: handleReceivedPeerData)
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
    
    private func setupARSceneConfiguration(worldMap: ARWorldMap? = nil) {
        guard ARWorldTrackingConfiguration.isSupported else { fatalError(LocalizedStrings.ARScreen.arFrameworkNotSupported) }
        
        let configuration = ARWorldTrackingConfiguration()
        var configurationOptions: ARSession.RunOptions = []
        
        configuration.planeDetection = .horizontal
        
        if let map = worldMap {
            configuration.initialWorldMap = map
            configurationOptions = [.resetTracking, .removeExistingAnchors]
        }
        
        if let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: ARSceneConstants.VirtualObjects.referenceObjectsGroupName, bundle: nil) {
            configuration.detectionObjects = referenceObjects
        }
        
        sceneView.session.run(configuration, options: configurationOptions)
        sceneView.session.delegate = self
        
        #if DEBUG
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        #endif
    }
    
    private func toggleIdleTimer(enabled: Bool) {
        UIApplication.shared.isIdleTimerDisabled = enabled
    }
    
    //MARK: - Actions
    
    @IBAction private func handleSceneTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touchPoint, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
        guard let firstHitTestResult = hitTestResults.first else { return }
        
        let anchor = ARAnchor(name: ARSceneConstants.VirtualObjects.defaultAnchorName, transform: firstHitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
        
        //notify connected peers about the object that we just placed in the scene
        
        guard let anchorData = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true) else { return }
        multipeerSession.sendToAllPeers(anchorData)
    }
    
    @IBAction func resetButtonTouchUpInside(_ sender: Any) {
        setupARSceneConfiguration()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shareButtonVC = segue.destination as? ShareButtonViewController {
            shareButtonViewController = shareButtonVC
            shareButtonViewController.delegate = self
        } else if let peersCounterVC = segue.destination as? PeerCounterViewController {
            peersCounterViewController = peersCounterVC
        }
    }
    
    //MARK: - Helper functions
    
    private func shareARSession() {
        sceneView.session.getCurrentWorldMap { [weak self] (worldMap, error) in
            guard let map = worldMap else { return }
            guard let mapData = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true) else { return }
            self?.multipeerSession.sendToAllPeers(mapData)
        }
    }
    
    private func handleReceivedPeerData(data: Data, peerID: MCPeerID) {
        if let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
            setupARSceneConfiguration(worldMap: worldMap)
        } else if let anchor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
            sceneView.session.add(anchor: anchor)
        } else {
            print(LocalizedStrings.MultipeerSession.receivedUnknownDataObject)
        }
    }
    
    private func loadObject() -> SCNNode? {
        return SCNNode(name: ARSceneConstants.VirtualObjects.resourceName)
    }
}

//MARK: - Delegates

extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // load new object
        if let anchorName = anchor.name,
            anchorName.elementsEqual(ARSceneConstants.VirtualObjects.defaultAnchorName),
            let objectNode = loadObject() {
            node.addChildNode(objectNode)
        } else if let objectAnchor = anchor as? ARObjectAnchor {
            //add bounding box to the detected real object
            let referenceObject = objectAnchor.referenceObject
            let objectScale = CGFloat(referenceObject.scale.x)
            let boundingBox = BoundingBoxNode(points: referenceObject.rawFeaturePoints.points, scale: objectScale)
            node.addChildNode(boundingBox)
        }
    }
}

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // update a screen label
        print(camera.trackingState.presentationString)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let status = frame.worldMappingStatus
        switch status {
        case .notAvailable, .limited, .extending:
            if status == .notAvailable {
                shareButtonViewController.progress = shareButtonViewController.progressSteps[0]
            } else if status == .limited {
                shareButtonViewController.progress = shareButtonViewController.progressSteps[1]
            } else {
                 shareButtonViewController.progress = shareButtonViewController.progressSteps[2]
            }
            shareButtonViewController.shareEnabled = false
        case  .mapped:
            shareButtonViewController.progress = shareButtonViewController.progressSteps[3]
            shareButtonViewController.shareEnabled = !multipeerSession.connectedPeers.isEmpty
        default: break
        }
        
        peersCounterViewController.peersCount = multipeerSession.connectedPeers.count
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
}

extension ARViewController: ShareButtonViewControllerDelegate {
    func didPressShareButton(_ shareButtonViewController: ShareButtonViewController) {
        shareARSession()
    }
}
