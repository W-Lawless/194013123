//
//  MonitorButton.swift
//  MyCabin
//
//  Created by Lawless on 5/4/23.
//

import SwiftUI

struct MonitorButton: View {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel
    
    let monitor: MonitorModel
    @State var selected: Bool
    let iconCallback: (MonitorModel) -> Void
    
    var body: some View {
        
        Image(selected ? "ic_monitor_on" : "ic_monitor_off")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 48, maxHeight: 48)
            .scaleEffect(selected ? 1.4 : 1)
            .hapticFeedback(feedbackStyle: .light) { _ in
                iconCallback(monitor)
            }
            .accessibilityIdentifier("\(monitor.id)")
        //TODO: - Long press 
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
