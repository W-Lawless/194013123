//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic<T: ParentViewModel>: View {
    
    @StateObject var coordinatesModel = PlaneViewCoordinates()

    @StateObject var topLevelViewModel: T
    @StateObject var viewModel: PlaneViewModel
    let navigation: HomeMenuCoordinator
    let options: PlaneSchematicDisplayMode
    
    @State var selectedZone: PlaneArea? = nil
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack { // VSTQ
                
                HStack(alignment: .center) { // HSTQ
                    
                    Image("plane_left_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    
                    VStack(alignment: .center, spacing: 0) { //VSTQ B
                        
                        ForEach(viewModel.plane.mapAreas) { area in
                            
                                AreaSubView<T>(selectedZone: $selectedZone, area: area, options: options, navigation: navigation)
                                    .if(options == .tempZones) {
                                        $0.modifier(TappableZone(area: area, selectedZone: $selectedZone))
                                    }
                                    .if(options == .lightZones) {
                                        $0.modifier(TappableZone(area: area, selectedZone: $selectedZone))
                                    }
                                    .environmentObject(topLevelViewModel)
                                    .environmentObject(coordinatesModel)
                            
                        } //: FOREACH
                        
                    } //: VSTQ B
                    
                    Image("plane_right_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    
                } //: HSTQ
                .padding(.horizontal, 34)
                .frame(height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
            } //: VSTQ
            
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


//MARK: - Area SubView

struct AreaSubView<T: ParentViewModel>: View {
    
    @EnvironmentObject var topLevelViewModel: T
    @EnvironmentObject var coordinatesModel: PlaneViewCoordinates
    @Binding var selectedZone: PlaneArea?
    
    let area: PlaneArea
    
    let options: PlaneSchematicDisplayMode
    let navigation: HomeMenuCoordinator

    @State var subviewHeightUnit: CGFloat = 0
    @State var subviewWidthUnit: CGFloat = 0

    @AppStorage("CurrentSeat") var selectedSeat: String = ""
//    let selectedSeat: String = UserDefaults.standard.string(forKey: "CurrentSeat") ?? ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            ForEach(area.seats ?? [SeatModel]()) { seat in
                if(seat.id == selectedSeat) {
                    SeatButton(id: seat.id, options: options, selected: true)
                        .modifier(PlaceIcon(rect: seat.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
                } else {
                    SeatButton(id: seat.id, options: options, selected: false)
                        .modifier(PlaceIcon(rect: seat.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
                }
            } //: FOR EACH
            
            ForEach(area.tables ?? [TableModel]()) { table in
                MiniTable(tableType: table.type)
                    .modifier(PlaceIcon(rect: table.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            } //: FOR EACH
            
            ForEach(area.divans ?? [DivanModel]()) { divan in
                DivanSeat(options: options)
                    .modifier(PlaceIcon(rect: divan.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            } //: FOR EACH
            
            if(options == .showShades) {
                ForEach(area.shades ?? [ShadeModel]()) { shade in
                    ShadeButton(shade: shade)
                        .modifier(PlaceIcon(rect: shade.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
                } //: FOR EACH
            }

        }
        .frame(width: (subviewWidthUnit * area.rect.w), height: (subviewHeightUnit * area.rect.h))
        .onAppear {
            let subviewHeight = coordinatesModel.containerHeightUnit * area.rect.h
            subviewHeightUnit = subviewHeight / area.rect.h
            
            let subviewWidth = coordinatesModel.containerWidthUnit * area.rect.w
            subviewWidthUnit = subviewWidth / area.rect.w
        }
        .if(options == .tempZones) { subview in
                subview
                    .opacity(selectedZone?.id == area.id ? 1 : 0.3)
                    .background(selectedZone?.id == area.id ? Color.yellow.opacity(0.3) : nil)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
        }

    }
    
}


//MARK: - Preview

struct PlaneSchematic_Previews: PreviewProvider {
    static var previews: some View {
        PlaneFactory.buildPlaneSchematic(topLevelViewModel: SeatsViewModel(), options: PlaneSchematicDisplayMode.onlySeats)
    }
}

