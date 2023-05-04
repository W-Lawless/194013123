//
//  LightsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import Foundation
import Combine

extension GCMSClient {
    
    func toggleLight(_ light: LightModel, cmd: LightState) {
        
        let endpoint = Endpoint<EndpointFormats.Put<LightModel.state>, LightModel.state>(path: .lights, stateUpdate: light.id)
        
        let encodeObj = LightModel.state(on: cmd.rawValue, brightness: cmd.rawValue == true ? 100 : 0)
        
        let callback = { lightStatus in
            print("put request data", lightStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
    }
    
}
