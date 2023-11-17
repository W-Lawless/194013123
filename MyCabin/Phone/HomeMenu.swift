//
//  Home.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct Home: View {
    
    let homeMenuButtonBuilder: (String, String, String, MenuRouter) -> HomeMenuButton
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            Color("PrimaryColor")
            
            VStack {
                HStack(alignment: .center, spacing: 32) {
                    
                    homeMenuButtonBuilder("ic_lights", "Lights", "LightsMenu", .lights)
                    Divider()
                        .background(Color.white)
                    homeMenuButtonBuilder("ic_windows", "Shades", "ShadesMenu", .shades)

                } //:HSTQ
                .padding(.top, 24)
                
                
                HStack(alignment: .center, spacing: 32) {
                    
                    homeMenuButtonBuilder("ic_temperature", "Temperature", "ClimateMenu", .climate)
                    Divider()
                        .background(Color.white)
                    homeMenuButtonBuilder("ic_change_seat", "Seats", "SeatsMenu", .seats)
                    
                } //:HSTQ

                
                
                HStack(alignment: .center, spacing: 32) {
                    homeMenuButtonBuilder("ic_presets", "Presets", "Presets", .presets)
                    Divider()
                        .background(Color.white)
                    homeMenuButtonBuilder("ic_settings", "Settings", "SettingsMenu", .settings)
                    
                } //: HSTQ
                .padding(.bottom, 24)
            }
        }
        
        
    }
}

struct HomeMenuButton: View {
    
    let image: String
    let label: String
    let uilabel: String
    let navHandler: () -> ()
    
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
            navHandler()
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
