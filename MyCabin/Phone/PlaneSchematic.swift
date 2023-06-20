//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic: View {
    
    @StateObject var coordinatesModel = PlaneViewCoordinates()
    @StateObject var viewModel: PlaneViewModel
    @State var options: PlaneSchematicDisplayMode
    @State var selectedZone: PlaneArea? = nil
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .custom) { // ZSTQ
                    
                if (options == .showLights || options == .lightZones) {
                    VStack(spacing: 32) {
                        
                        ZoneButton(displayOptions: $options, targetOption: .lightZones, imageName: "square.on.square")
                        ZoneButton(displayOptions: $options, targetOption: .showLights, imageName: "lightbulb.fill")
                        
                    }
                    .padding(.horizontal, 18)
                }
                
                if(options == .showShades) {
                    VStack(spacing: 32) {
                        ShadeGroupButton(group: .all, text: "All")
                        ShadeGroupButton(group: .left, text: "Left")
                        ShadeGroupButton(group: .right, text: "Right")
                    }
                    .padding(.horizontal, 18)
                }
                
                HStack(alignment: .center) { // HSTQ
                    
                    Image("plane_left_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    
                    VStack(alignment: .center, spacing: 0) { //VSTQ B
                        
                        if(options == .tempZones) {
                            //TODO: - Force unwrap fix
                            AreaSubView(selectedZone: $selectedZone, area: viewModel.plane.parentArea!, options: options)
                                .environmentObject(coordinatesModel)

                        } else {
                            
                            
                            ForEach(viewModel.plane.mapAreas) { area in
                                
                                AreaSubView(selectedZone: $selectedZone, area: area, options: options)
                                    .if(options == .lightZones) {
                                        $0.modifier(TappableZone(area: area, selectedZone: $selectedZone))
                                    }
                                    .environmentObject(coordinatesModel)
                                
                            } //: FOREACH
                            
                        } //: CONDITIONAL
                        
                    } //: VSTQ B
                    
                    Image("plane_right_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    
                } //: HSTQ
                .padding(.horizontal, 34)
                .frame(height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
            } //: ZSTQ
//            .border(.red, width: 1)
            .padding(.horizontal, 12)
            
        } //: GEO
        .passGeometry { geo in
            
            coordinatesModel.containerViewHeight = geo.size.height
            coordinatesModel.containerViewWidth = geo.size.width
            
            if let parentArea = viewModel.plane.parentArea {

                coordinatesModel.containerWidthUnit = (geo.size.width * 0.39) / parentArea.rect.w //self.widthUnit
                coordinatesModel.containerHeightUnit = (geo.size.height) / parentArea.rect.h //self.heightUnit

            }
        } //: PASS GEO UTIL

    } //: BODY
    
}

struct ZoneButton: View {
  
    @Binding var displayOptions: PlaneSchematicDisplayMode
    let targetOption: PlaneSchematicDisplayMode
    let imageName: String
    
    var body: some View {
        Button {
            displayOptions = targetOption
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .overlay (
                    RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 1).frame(width: 48, height: 48)
                )
        }
    }
}


struct ShadeGroupButton: View {
  
    @ObservedObject var viewModel = StateFactory.shadesViewModel
    let group: ShadeGroup
    let text: String
    
    var body: some View {
        Button {
            if(!viewModel.showPanel) {
                viewModel.showPanel = true
            }
//            viewModel.groupSelection = group
            viewModel.selectAll(in: group)
        } label: {
            VStack {
                Image("ico_advanced_off")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .overlay (
                        RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 1).frame(width: 48, height: 48)
                    )
                Text(text)
            }
        }
    }
}

//MARK: - Preview

struct PlaneSchematic_Previews: PreviewProvider {
    static var previews: some View {
        PlaneFactory.buildPlaneSchematicPreview(options: .onlySeats)
    }
}

