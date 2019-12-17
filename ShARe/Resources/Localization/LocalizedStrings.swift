//
//  LocalisedStrings.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 16/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    private init() {}
    
    struct MultipeerSession {
        private init() { }
        
        static let failedToSendDataToPeers = NSLocalizedString("PEER_FAILED_TO_SEND_DATA", comment: "")
        static let receivedUnknownDataObject = NSLocalizedString("PEER_RECEIVED_UNKNOWN_DATA", comment: "")
    }
    
    struct ARScreen {
        private init() { }
        
        static let arFrameworkNotSupported = NSLocalizedString("AR_KIT_NOT_SUPPORTED", comment: "")
    }
}
