//
//  SeatsView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import SwiftUI

struct SeatSelection<Content: View>: View {
    
    let planeView: () -> Content
    
    var body: some View {
        planeView()
    }
}

