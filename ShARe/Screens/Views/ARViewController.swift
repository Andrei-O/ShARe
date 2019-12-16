//
//  ARViewController.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 16/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupARSceneConfiguration()
        toggleIdleTimer(enabled: true)
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
}

//MARK: - Delegates

extension ARViewController: ARSCNViewDelegate {
    
}

extension ARViewController: ARSessionDelegate {
    
}
