//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic<AViewModel: ViewModelWithSubViews & ObservableObject>: View {
    
    @StateObject var coordinatesModel = PlaneViewCoordinates()

    @ObservedObject var topLevelViewModel: AViewModel
    @ObservedObject var viewModel: PlaneViewModel
    var navigation: HomeMenuCoordinator
    let options: PlaneSchematicDisplayMode
    
    @State var viewHeight: CGFloat = 0
    @State var viewWidth: CGFloat = 0
    @State var widthUnit: CGFloat = 0
    @State var heightUnit: CGFloat = 0
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
                            if(area.id != "AIRPLANE_AREA") { // Filter Areas
                                AreaSubView(topLevelViewModel: topLevelViewModel, coordinatesModel: coordinatesModel, selectedZone: $selectedZone, area: area, options: options, navigation: navigation)
                                    .if(options == .tempZones) {
                                        $0.modifier(TappableZone(area: area, selectedZone: $selectedZone))
                                    }
                                    .if(options == .lightZones) {
                                        $0.modifier(TappableZone(area: area, selectedZone: $selectedZone))
                                    }
                            } //: CONDITIONAL
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
            self.viewHeight = geo.size.height
            coordinatesModel.containerViewHeight = self.viewHeight
            
            self.viewWidth = geo.size.width
            coordinatesModel.containerViewWidth = self.viewWidth
            
            viewModel.plane.mapAreas.forEach { area in
                if(area.id == "AIRPLANE_AREA") {
                    self.widthUnit = (geo.size.width * 0.39) / area.rect.w
                    coordinatesModel.containerWidthUnit = self.widthUnit
                    
                    self.heightUnit = (geo.size.height) / area.rect.h
                    coordinatesModel.containerHeightUnit = self.heightUnit
                }
            }
        } //: PASS GEO UTIL

    } //: BODY
    

}


//MARK: - Area SubView

struct AreaSubView<AViewModel: ViewModelWithSubViews & ObservableObject>: View {
    
    @ObservedObject var topLevelViewModel: AViewModel
    @ObservedObject var coordinatesModel: PlaneViewCoordinates
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
                    SeatButton(topLevelViewModel: topLevelViewModel, seat: seat, navigation: navigation, options: options, selected: true)
                        .modifier(PlaceIcon(element: seat, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
                } else {
                    SeatButton(topLevelViewModel: topLevelViewModel, seat: seat, navigation: navigation, options: options, selected: false)
                        .modifier(PlaceIcon(element: seat, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
                }
            } //: FOR EACH
            
            ForEach(area.tables ?? [TableModel]()) { table in
                MiniTable(table: table)
                    .modifier(PlaceIcon(element: table, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            } //: FOR EACH
            
            ForEach(area.divans ?? [DivanModel]()) { divan in
                DivanSeat(divan: divan, navigation: navigation, options: options)
                    .modifier(PlaceIcon(element: divan, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            } //: FOR EACH
            
            if(options == .showShades) {
                ForEach(area.shades ?? [ShadeModel]()) { shade in
                    ShadeButton(topLevelViewModel: topLevelViewModel as! ShadesViewModel, shade: shade, options: options)
                        .modifier(PlaceIcon(element: shade, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
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

