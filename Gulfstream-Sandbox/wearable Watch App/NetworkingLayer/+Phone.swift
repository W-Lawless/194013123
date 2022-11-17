//
//  Phone.swift
//  wearable Watch App
//
//  Created by Lawless on 11/9/22.
//

import Foundation
import WatchConnectivity

class PhoneConnection: NSObject, ObservableObject, WCSessionDelegate {
    
    /// Data FROM Phone
    ///
    ///  Due to the nature of Watch Connectivity requiriing both apps in the foreground,
    ///  this is unreliable way to detect state, much better to simply depend on internal implementation of cabin heartbeat monitor 
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        DispatchQueue.main.async {
//            let out = message["lostConnection"] as? Bool ?? false
//            print("***** Lost Connection?", out)
//            self.lostConnection = message["lostConnection"] as? Bool ?? false
//        }
    }
    
    func sendToPhone(data: [String: Any]) {
        do {
            print("doing something")
            try session.updateApplicationContext(data)
        } catch {
            print("Error sending context to phone, \(error)")
        }
    }
}

extension PhoneConnection {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
