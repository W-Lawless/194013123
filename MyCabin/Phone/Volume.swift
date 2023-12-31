//
//  Volume.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import SwiftUI

struct Volume: View {
    
    @StateObject var viewModel: MediaViewModel
    @State var vol: Int = 0
    
    func callback(_ speaker: SpeakerModel) {
//        viewModel.updateState(for: speaker)
    }
    
    var body: some View {
        Group {
            
                List(viewModel.speakers) { speaker in
                    VolumeControl(speaker: speaker, cb: callback)
                }

        }
    }
}


 /// Use mutating function on Swift UI view ?
struct VolumeControl: View {
    
    let speaker: SpeakerModel
    @State var vol: Int
    var callback: (_ speaker: SpeakerModel) -> ()
    
    init(speaker: SpeakerModel, vol: Int = 0, cb: @escaping (_ speaker: SpeakerModel) -> ()) {
        self.speaker = speaker
        self.vol = speaker.state.volume
        self.callback = cb
    }
    
    func onInc() {
        self.vol += 1
        var copy = speaker
        copy.state.volume = vol
        self.callback(copy)
    }
    
    func onDec() {
        self.vol -= 1
        var copy = speaker
        copy.state.volume = vol
        self.callback(copy)
    }
    
    var body: some View {
        Group {
            Text(speaker.id)
            HStack {
                Stepper("Volume \(String(describing:$vol.wrappedValue))", onIncrement: onInc, onDecrement: onDec)
            }
        }
    }
}
