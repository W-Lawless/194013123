//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic: View {
    var body: some View {
        IceCream(heightRadiusRatio: 6)
    }
}

//MARK: - Shapes

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
        PlaneSchematic()
    }
}
