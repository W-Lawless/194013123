//
//  MonitorButton.swift
//  MyCabin
//
//  Created by Lawless on 5/4/23.
//

import SwiftUI

//TODO: Remove static references

struct MonitorButton: View {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel
    
    let monitor: MonitorModel
    @State var selected: Bool
    
    var body: some View {
        
        Image(selected ? "ic_monitor_on" : "ic_monitor_off")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 48, maxHeight: 48)
            .scaleEffect(selected ? 1.4 : 1)
            .hapticFeedback(feedbackStyle: .light, cb: mediaViewModel.monitorIconCallback, cbArgs: monitor)
            .accessibilityIdentifier("\(monitor.id)")
//            .longPressHaptic {
//                print("ay")
//                pressed.toggle()
//                longPress = true
//            }
    }
}

//struct MonitorButton_Previews: PreviewProvider {
//    static var previews: some View {
//        MonitorButton(assetName: "ic_monitor_off")
//    }
//}
