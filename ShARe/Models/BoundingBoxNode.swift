//
//  BoundingBoxNode.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 17/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class BoundingBoxNode: SCNNode {
    
    init(points: [SIMD3<Float>], scale: CGFloat, color: UIColor = .cyan) {
        super.init()
        
        var localMin = SIMD3<Float>(repeating: Float.greatestFiniteMagnitude)
        var localMax = SIMD3<Float>(repeating: -Float.greatestFiniteMagnitude)
        
        for point in points {
            localMin = min(localMin, point)
            localMax = max(localMax, point)
        }
        
        simdPosition += (localMax + localMin) / 2
        let extent = localMax - localMin
        
        let wireFrame = SCNNode()
        let boxGeometry = SCNBox(width: CGFloat(extent.x), height: CGFloat(extent.y), length: CGFloat(extent.z), chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = color
        boxGeometry.firstMaterial?.isDoubleSided = true
        
        wireFrame.geometry = boxGeometry
        
        setupShaderOn(geometry: boxGeometry)
        
        addChildNode(wireFrame)
    }
    
    private func setupShaderOn(geometry: SCNGeometry) {
        let shaderPath = Bundle.main.path(
            forResource: ARSceneConstants.VirtualObjects.wireframeShaderName,
            ofType: ARSceneConstants.VirtualObjects.metalExtension,
            inDirectory: ARSceneConstants.VirtualObjects.directory
        )
        
        guard let path = shaderPath,
            let shader = try? String(contentsOfFile: path, encoding: .utf8) else { return }
        
        geometry.firstMaterial?.shaderModifiers = [.surface: shader]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
