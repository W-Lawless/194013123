//
//  Shades.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import SwiftUI

struct Shades<Content: View>: View {
    
    @ObservedObject var viewModel: ShadesViewModel
    let shadeControlBuilder: () -> ShadeControl
    let planeView: () -> Content
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            planeView()
            
            VStack(alignment: .center) {
                if(viewModel.showPanel) {
                    shadeControlBuilder()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, 18)
            .background(Color.black)
            .frame(height:108, alignment: .top)
            
        }
        .environmentObject(viewModel)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.clearSelection()
        }
        
    }
    
}


