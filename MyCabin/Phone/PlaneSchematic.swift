//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic: View {
    
    @ObservedObject var viewModel: PlaneViewModel
    @StateObject var coordinatesModel = PlaneViewCoordinates()
    var navigation: HomeMenuCoordinator
    @State var viewHeight: CGFloat = 0
    @State var viewWidth: CGFloat = 0
    @State var widthUnit: CGFloat = 0
    @State var heightUnit: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) { // HSTQ
                Image("plane_left_side")
                    .resizable()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                VStack(alignment: .center, spacing: 0) { // VSTQ A
                    VStack(alignment: .center, spacing: 0) { //VSTQ B
                        ForEach(viewModel.plane?.areas ?? [PlaneArea]()) { area in
                            if let area = area { //Unwrap
                                if let seats = area.seats { //Unwrap seats
                                    if(!seats.isEmpty) { //Discard areas without seats
                                        if(area.id != "Fwd Lavatory" && area.id != "Aft-Lav" && area.id != "CREW") { //Discard Unneeded Seats
                                            AreaSubView(area: area, coordinatesModel: coordinatesModel, navigation: navigation)
                                        } //: CONDITIONAL
                                    } //: CONDITIONAL
                                } //: UNWRAP
                            } //: UNWRAP
                        } //: FOREACH
                    } //: VSTQ B
                } //: VSTQ A
                Image("plane_right_side")
                    .resizable()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
            } //: HSTQ
            .padding(.vertical, 18)
            .padding(.horizontal, 34)
            .frame(height: geometry.size.height)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .passGeometry { geo in
            self.viewHeight = geo.size.height
            coordinatesModel.containerViewHeight = self.viewHeight
            
            self.viewWidth = geo.size.width
            coordinatesModel.containerViewWidth = self.viewWidth
            
            viewModel.plane?.areas.forEach { area in
                if(area.id == "AIRPLANE_AREA") {
                    self.widthUnit = (geo.size.width * 0.39) / area.rect.w
                    coordinatesModel.containerWidthUnit = self.widthUnit
                    
                    self.heightUnit = (geo.size.height * 0.85) / area.rect.h
                    coordinatesModel.containerHeightUnit = self.heightUnit
                    print("parent height", self.heightUnit * area.rect.h)
                }
            }
        }
        
    }
    
}


//MARK: - Sub Element Views

struct AreaSubView: View {
    
    let area: PlaneArea
    @ObservedObject var coordinatesModel: PlaneViewCoordinates
    var navigation: HomeMenuCoordinator
    @State var subviewHeightUnit: CGFloat = 0
    @State var subviewWidthUnit: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(area.seats ?? [SeatModel]()) { seat in
                SeatButton(seat: seat, navigation: navigation)
                    .rotationEffect(Angle(degrees: seat.rect.r))
                    .position(x:
                                /// Position Center according to API coordinate data & add half the width/height to the coordinate to align image by top left corner
                                ((subviewWidthUnit * seat.rect.x) + ((subviewWidthUnit*seat.rect.w)/2)),
                              y: ((subviewHeightUnit * seat.rect.y) + ((subviewHeightUnit * seat.rect.h)/2))
                )
            }
        }
        .frame(width: (subviewWidthUnit * area.rect.w), height: (subviewHeightUnit * area.rect.h))
        .onAppear {
            let subviewHeight = coordinatesModel.containerHeightUnit * area.rect.h
            subviewHeightUnit = subviewHeight / area.rect.h
            
            let subviewWidth = coordinatesModel.containerWidthUnit * area.rect.w
            subviewWidthUnit = subviewWidth / area.rect.w
        }
    }
    
    
}


struct SeatButton: View {

    var seat: SeatModel
    var navigation: HomeMenuCoordinator
    @State var selected: Bool = false
    
    var body: some View {
        Image(selected ? "seat_selected" : "seat_selectable")
            .resizable()
            .scaledToFit()
            .frame(width:32, height: 32)
            .hapticFeedback(feedbackStyle: .light) {
                selected.toggle()
                UserDefaults.standard.set(seat.id, forKey: "CurrentSeat")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    navigation.popToRoot()
                }
            }
    }
}



//MARK: - Preview

struct PlaneSchematic_Previews: PreviewProvider {
    static var previews: some View {
        AppFactory.buildPlaneSchematic()
    }
}



//MARK: - Util Extension
///TODO: Move to Util Folder

public struct GeometryPasser: View {
    private let op: (GeometryProxy) -> Void
    public init(_ op: @escaping (GeometryProxy) -> Void) {
        self.op = op
    }
    
    public var body: some View {
        GeometryReader { proxy in
            Color.clear.onAppear {
                op(proxy)
            }
        }
    }
}

extension View {
    public func passGeometry(_ op: @escaping (GeometryProxy) -> Void) -> some View {
        self.background(
            GeometryPasser(op)
        )
    }
}


struct IceCream: Shape {
    let heightRadiusRatio: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.height / (1 + heightRadiusRatio)
        let bottom = CGPoint(x: rect.width / 2, y: rect.height)
        let left = CGPoint(x: bottom.x - radius, y: radius)
        let right = CGPoint(x: bottom.x + radius, y: radius)
        path.move(to: bottom)
        path.addLine(to: left)
        path.addLine(to: right)
        path.addArc(center: CGPoint(x: bottom.x, y: radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
        path.move(to: right)
        path.addLine(to: bottom)
        return path
    }
}
