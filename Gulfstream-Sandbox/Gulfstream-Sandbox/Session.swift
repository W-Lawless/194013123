//
//  SessionConfig.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import Foundation

struct Session {
    
    let session: URLSession
    
    static var shared: URLSession  {
        get {
            return Session().session
        }
    }

    private init() {
        let customNetworkReqConfig = URLSessionConfiguration.ephemeral
        customNetworkReqConfig.timeoutIntervalForRequest = 29
        customNetworkReqConfig.timeoutIntervalForResource = 29
        self.session = URLSession(configuration: customNetworkReqConfig)
    }
}
