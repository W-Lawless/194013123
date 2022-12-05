//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic: View {
    
    let viewModel: SeatsViewModel
    @State var selected: Bool = false
    
    var body: some View {
//        IceCream(heightRadiusRatio: 6)
        GeometryReader { geometry in
            
            HStack(alignment: .center) {
                Image("plane_left_side")
                    .resizable()
                    .scaledToFit()
                    .frame(height: geometry.size.height * 0.4)
                Spacer()
                VStack(alignment: .center, spacing: 64) {
                    ForEach(viewModel.seatList ?? [SeatModel]()) { seat in
                        SeatButton()
                    }
//                    HStack {
//                        SeatButton()
//                        SeatButton()
//                        SeatButton()
//                    }
                }
                Spacer()
                Image("plane_right_side")
                    .resizable()
                    .scaledToFit()
                    .frame(height: geometry.size.height * 0.4)
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 34)
//            .border(Color.white)
            .frame(height: geometry.size.height)
        }
    }
}



//MARK: - Shapes

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


//MARK: - Preview

struct PlaneSchematic_Previews: PreviewProvider {
    static var previews: some View {
        AppFactory.buildPlaneSchematic()
    }
}
