//
//  Home.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct Home: View {
    
    var navigateTo: (_ route: MenuRouter) -> ()
    
    var body: some View {
        
        Group {
            
            HStack(alignment: .center, spacing: 32) {
                
                HomeMenuButton(image: "ic_lights", label: "Lights", navHandler: navigateTo, destination: .lights, uilabel: "LightsMenu")
                Divider()
                    .background(Color.white)
                HomeMenuButton(image: "ic_windows", label: "Shades", navHandler: navigateTo, destination: .shades, uilabel: "ShadesMenu")

            } //:HSTQ
            .padding(.top, 24)
            
            
            HStack(alignment: .center, spacing: 32) {
                
                HomeMenuButton(image: "ic_temperature", label: "Temperature", navHandler: navigateTo, destination: .climate, uilabel: "ClimateMenu")
                Divider()
                    .background(Color.white)
                HomeMenuButton(image: "ic_change_seat", label: "Seats", navHandler: navigateTo, destination: .seats, uilabel: "SeatsMenu")
                
            } //:HSTQ

            
            
            HStack(alignment: .center, spacing: 32) {
                HomeMenuButton(image: "ic_presets", label: "Presets", navHandler: navigateTo, destination: .presets, uilabel: "Presets")
                Divider()
                    .background(Color.white)
                HomeMenuButton(image: "ic_settings", label: "Settings", navHandler: navigateTo, destination: .settings, uilabel: "SettingsMenu")
                
            } //: HSTQ
            .padding(.bottom, 24)
        }
        
    }
}

struct HomeMenuButton: View {
    
    let image: String
    let label: String
    let navHandler: (_ route: MenuRouter) -> ()
    let destination: MenuRouter
    let uilabel: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
        } //:VSTQ
        .accessibilityIdentifier(uilabel)
        .hapticFeedback(feedbackStyle: .light) { _ in
            navHandler(destination)
        }
        .frame(width: 98)
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}

//MARK: - Animated Pulse

//struct Pulse: View {
//
//    @State var animate = false
//    @State var circleXOffset: Double = 0
//    @State var circleYOffset: Double = 0
//
//    let animationStyle = Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
//
//    var body: some View {
//
//        ZStack {
//
//            Circle().fill(Color.red.opacity(0.25)).frame(width: 350, height: 350)
//                .scaleEffect(self.animate ? 0.7 : 0)
//
//            Circle().fill(Color.red.opacity(0.30)).frame(width: 250, height: 250)
//                .scaleEffect(self.animate ? 0.7 : 0)
//
//            Circle().fill(Color.red.opacity(0.35)).frame(width: 150, height: 150)
//                .scaleEffect(self.animate ? 0.7 : 0)
//
//            Circle().fill(Color.red.opacity(0.4)).frame(width: 30, height: 30)
//                .offset(x: circleXOffset, y: circleYOffset)
//                .gesture(DragGesture().onChanged(dragCircle(value:)))
//
//
//        }.onAppear {
//            self.animate.toggle()
//        }
//        .background(Color.secondary)
//        .animation(self.animationStyle, value: self.animate)
//        .gesture(DragGesture().onEnded(dragCircle(value:)))
//
//    }
//
//    func centerCircle(value: DragGesture.Value) {
//        let vector = CGVector(dx: value.location.x, dy: value.location.y)
//        let xOffset = vector.dx
//        let yOffset = vector.dy
//
//        withAnimation(Animation.linear(duration: 0.1)) { self.circleXOffset = xOffset; self.circleYOffset = yOffset }
//
//    }
//
//    func dragCircle(value: DragGesture.Value) {
//        let vector = CGVector(dx: value.location.x, dy: value.location.y)
//        let xOffset = vector.dx
//        let yOffset = vector.dy
//
//        withAnimation(Animation.linear(duration: 0.1)) { self.circleXOffset = xOffset; self.circleYOffset = yOffset }
//
//    }
//
//}
