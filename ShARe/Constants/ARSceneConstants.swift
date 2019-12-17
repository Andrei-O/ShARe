//
//  ARSceneConstants.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 16/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import Foundation

struct ARSceneConstants {
    private init() { }
    
    struct VirtualObjects {
        private init() { }
        
        static let defaultAnchorName = "plantAnchor"
        static let resourceName = "plant"
        static let wireframeShaderName = "wireframe_shader"
        static let metalExtension = "metal"
        static let resourceExtension = "scn"
        static let directory = "Assets.scnassets"
        static let referenceObjectsGroupName = "referenceObjects"
    }
}
