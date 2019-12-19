//
//  ARSceneConstants.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 16/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import Foundation
import UIKit

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
    
    struct Colors {
        private init() { }
        
        static let shareButtonDisabled = UIColor(named: "shareButtonDisabledColor")!
        static let shareButtonEnabled = UIColor(named: "shareButtonEnabledColor")!
    }
}
