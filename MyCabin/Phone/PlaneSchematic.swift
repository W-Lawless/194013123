//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic: View {
    
    @ObservedObject var viewModel: PlaneViewModel
    
    @State var viewHeight: CGFloat = 0
    @State var viewWidth: CGFloat = 0
    @State var widthUnit: CGFloat = 0
    @State var heightUnit: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Image("plane_left_side")
                    .resizable()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
//                Spacer()
                VStack(alignment: .center, spacing: 0) { // VSTQ A
                    VStack(alignment: .center, spacing: 0) { //VSTQ B
                        ForEach(viewModel.plane?.areas ?? [PlaneArea]()) { area in
                            if let area = area { //Unwrap
                                if let seats = area.seats { //Unwrap seats
                                    if(!seats.isEmpty) { //Discard areas without seats
                                        if(area.id != "Fwd Lavatory" && area.id != "Aft-Lav" && area.id != "CREW") { //Discard Unneeded Seats
                                            AreaSubView(area: area, widthUnit: widthUnit, heightUnit: heightUnit)
                                        }
                                    }
                                }
                            }
                        } //: FOREACH
                    } //: VSTQ B
                } //: VSTQ A
//                Spacer()
                Image("plane_right_side")
                    .resizable()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 34)
            .frame(height: geometry.size.height)
        }
        .passGeometry { geo in
            self.viewHeight = geo.size.height
            self.viewWidth = geo.size.width
            viewModel.plane?.areas.forEach { area in
                if(area.id == "AIRPLANE_AREA") {
                    self.widthUnit = (geo.size.width * 0.5) / CGFloat(area.rect.w)
                    self.heightUnit = (geo.size.height * 0.85) / CGFloat(area.rect.h)
                }
            }
        }
        
    }
    
}


//MARK: - Sub Element Views

struct AreaSubView: View {
    
    let area: PlaneArea
    let widthUnit: CGFloat
    let heightUnit: CGFloat
    @State var subviewHeight: CGFloat?
    @State var subviewWidth: CGFloat?
    
    var body: some View {
        HStack(alignment: .top){
            ForEach(area.seats ?? [SeatModel]()) { seat in
                SeatButton()
            }
        }
        .frame(width: (widthUnit * area.rect.w), height: (heightUnit * area.rect.h))
//        .offset(x: (widthUnit * area.rect.x), y: (heightUnit * area.rect.y))
        .border(.white, width: 1)
        .onAppear {
            subviewHeight = heightUnit * area.rect.h
            print(heightUnit * area.rect.h)
            subviewWidth = widthUnit * area.rect.w
            print(widthUnit * area.rect.w)
        }
    }
    
    
}


struct SeatButton: View {
    
    @State var selected: Bool = false
    
    var body: some View {
        Image(selected ? "seat_selected" : "seat_selectable")
            .resizable()
            .scaledToFit()
            .frame(width:32, height: 32)
            .onTapGesture {
                selected.toggle()
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
