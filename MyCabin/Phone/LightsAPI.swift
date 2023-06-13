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
        
        var encodeObj = LightModel.state(on: cmd.rawValue, brightness: 50)
        
        if(light.brightness.dimmable) {
            if(cmd == .ON) {
                encodeObj.brightness = 50
            } else {
                encodeObj.brightness = 0
            }
        }
        
        let callback = { lightStatus in
            print("put request data", lightStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
    }
    
    func adjustBrightness(_ light: LightModel, brightness: Int) {
        
        let endpoint = Endpoint<EndpointFormats.Put<LightModel.state>, LightModel.state>(path: .lights, stateUpdate: light.id)
        
        let encodeObj = LightModel.state(on: true, brightness: brightness)
        
        let callback = { lightStatus in
            print("put request data", lightStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
        
    }
    
}
