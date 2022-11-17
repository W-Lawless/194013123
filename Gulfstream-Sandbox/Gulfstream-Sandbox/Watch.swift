//
//  WatchConnection.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import Foundation
import WatchConnectivity

class WatchConnection: NSObject, ObservableObject, WCSessionDelegate {

    /// Data FROM Watch

    var session: WCSession
    init(session: WCSession = .default){
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        let string = (applicationContext["message"] as? String)!
//        DispatchQueue.main.async {
//            self.message = string
//        }
    }

    

}


// MARK: - Protocol Stubs

extension WatchConnection {
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
