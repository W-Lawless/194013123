//
//  ContentView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless Sharpe on 11/3/22.
//

import SwiftUI
import Combine

struct Loading: View {
    
    var api: CabinAPI
    
    var body: some View {
        VStack {
            
            Image(systemName: "globe")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.white)
            
            Spacer()
            
            ProgressView()

            Spacer()
            
            Text("Connecting to Cabin")
                .fontWeight(.bold)
                .font(.subheadline)
        } //: VSTQ
        .padding()
        .frame(height: 180)
        .onAppear {
            api.monitor.stopMonitor()
            api.monitor.startMonitor(interval: 3.0, callback: api.monitorCallback)
        }
        .onDisappear{
//            print("view fading. . .")
        }
    }
}

// TODO::
//struct Loading_Previews: PreviewProvider {
//    let connectionPublisher = CurrentValueSubject<Bool, Never>(false)
//    let cabin = CabinAPI(publisher: connectionPublisher)
//
//    static var previews: some View {
//        Loading(api: cabin)
//    }
//}
