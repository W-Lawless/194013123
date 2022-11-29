//
//  Loading.swift
//  wearable Watch App
//
//  Created by Lawless on 11/15/22.
//

import SwiftUI

struct Loading: View {
        
    var body: some View {
        VStack {
            
            ProgressView()
            
            Spacer()
            
            
            Text("Connect Phone to Cabin via WiFi")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .font(.caption)
    
            
        } //: VSTQ
        .padding()
        .frame(height: 140)

    }
}


struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
