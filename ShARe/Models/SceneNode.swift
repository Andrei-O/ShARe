//
//  SceneNode.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 16/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import SceneKit

extension SCNNode {
    convenience init?(name: String) {
        guard
            let sceneUrl = Bundle.main.url(
                forResource: name,
                withExtension: ARSceneConstants.VirtualObjects.resourceExtension,
                subdirectory: ARSceneConstants.VirtualObjects.directory
            ),
            let sceneNode = SCNReferenceNode(url: sceneUrl)
            else { return nil }
        
        sceneNode.load()
        
        self.init()
        
        addChildNode(sceneNode)
    }
}


