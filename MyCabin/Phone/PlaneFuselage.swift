//
//  PlaneFuselage.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct PlaneFuselage<Content: View>: View {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel //Needs reference to trigger contextual re-paint
    
    let areaSubView: () -> Content
    
    var body: some View {
        areaSubView()
    }
    
}
