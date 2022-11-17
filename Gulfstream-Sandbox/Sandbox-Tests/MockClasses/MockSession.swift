//
//  MockSession.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/17/22.
//

import Foundation

struct MockSession {
    
    let session: URLSession
    
    static var shared: URLSession  {
        get {
            return MockSession().session
        }
    }

    private init() {
        let customNetworkReqConfig = URLSessionConfiguration.ephemeral
        customNetworkReqConfig.timeoutIntervalForRequest = 29
        customNetworkReqConfig.timeoutIntervalForResource = 29
        self.session = URLSession(configuration: customNetworkReqConfig)
    }
}
