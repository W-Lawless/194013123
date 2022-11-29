//
//  +Session.swift
//  wearable Watch App
//
//  Created by Lawless on 11/15/22.
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
        customNetworkReqConfig.timeoutIntervalForRequest = 30
        customNetworkReqConfig.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: customNetworkReqConfig)
    }
}
