//
//  SpeakersAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Combine


extension GCMSClient {
    
    func assignSourceToSpeaker(_ speaker: SpeakerModel, source: SourceModel) {
        
        print("ASSIGNING SOURCE TO MONITOR", source.id, speaker.id)
        
        let endpoint = Endpoint<EndpointFormats.Put<SpeakerSourceAssignment>, SpeakerState>(path: .speakers, stateUpdate: speaker.id)
        let encodeObj = SpeakerSourceAssignment(source: source.id)
            
        let callback = { speakerStatus in
            print("put request data", speakerStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
    }

    func toggleMute(_ speaker: SpeakerModel, cmd: Bool) {
        let endpoint = Endpoint<EndpointFormats.Put<MuteCommand>, SpeakerState>(path: .speakers, stateUpdate: speaker.id)
        let encodeObj = MuteCommand(mute: cmd)
            
        let callback = { speakerStatus in
            print("put request data", speakerStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
    }
    
    func setVolume(_ speaker: SpeakerModel, volume: Int) {
        let endpoint = Endpoint<EndpointFormats.Put<VolumeCommand>, SpeakerState>(path: .speakers, stateUpdate: speaker.id)
        let encodeObj = VolumeCommand(volume: volume)
            
        let callback = { speakerStatus in
            print("put request data", speakerStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
    }
    
}

