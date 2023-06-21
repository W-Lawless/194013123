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
    @State var someSetting: String = (UserDefaults.standard.string(forKey: "someSetting") ?? "DefaultValue")
    
    var body: some View {
        
        Group {

            HStack(alignment: .center, spacing: 72) {

                VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "lightbulb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                        Text("Lights")
                } //: VSTQ
                .accessibilityIdentifier("LightsMenu")
                .hapticFeedback(feedbackStyle: .light) { _ in
                    navigateTo(.lights)
                }

                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "uiwindow.split.2x1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Text("Shades")
                    .foregroundColor(.white)
                } //: VSTQ
                .accessibilityIdentifier("ShadesMenu")
                .hapticFeedback(feedbackStyle: .light) { _ in
                    navigateTo(.shades)
                }
            } //:HSTQ
            .frame(height:160)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)


            HStack(alignment: .center, spacing: 32) {

                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "thermometer.sun")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Text("Temperature")
                    .foregroundColor(.white)
                } //: VSTQ
                .accessibilityIdentifier("ClimateMenu")
                .hapticFeedback(feedbackStyle: .light) { _ in
                    navigateTo(.climate)
                }
                .frame(width: 98)
                .clipShape(RoundedRectangle(cornerRadius: 4))

                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "s.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Text("Seats")
                    .foregroundColor(.white)
                } //:VSTQ
                .accessibilityIdentifier("SeatsMenu")
                .hapticFeedback(feedbackStyle: .light) { _ in
                    navigateTo(.seats)
                }
                .frame(width: 98)
            } //:HSTQ
            .frame(height:160)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)


            HStack(alignment: .center, spacing: 72) {

                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "list.bullet.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Text("Presets")
                    .foregroundColor(.white)
                } //: VSTQ
                .accessibilityIdentifier("Presets")
                .hapticFeedback(feedbackStyle: .light) { _ in
                    navigateTo(.presets)
                }

                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Text("Settings")
                    .foregroundColor(.white)
                } //: VSTQ
                .accessibilityIdentifier("SettingsMenu")
                .hapticFeedback(feedbackStyle: .light) { _ in
                    navigateTo(.settings)
                }
            } //: HSTQ
            .frame(height:160)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 2)
        )

    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}

//MARK: - Animated Pulse

struct Pulse: View {
    
    @State var animate = false
    @State var circleXOffset: Double = 0
    @State var circleYOffset: Double = 0

    let animationStyle = Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
    
    var body: some View {
        
        ZStack {
            
            Circle().fill(Color.red.opacity(0.25)).frame(width: 350, height: 350)
                .scaleEffect(self.animate ? 0.7 : 0)
            
            Circle().fill(Color.red.opacity(0.30)).frame(width: 250, height: 250)
                .scaleEffect(self.animate ? 0.7 : 0)
            
            Circle().fill(Color.red.opacity(0.35)).frame(width: 150, height: 150)
                .scaleEffect(self.animate ? 0.7 : 0)
            
            Circle().fill(Color.red.opacity(0.4)).frame(width: 30, height: 30)
                .offset(x: circleXOffset, y: circleYOffset)
                .gesture(DragGesture().onChanged(dragCircle(value:)))

            
        }.onAppear {
            self.animate.toggle()
        }
        .background(Color.secondary)
        .animation(self.animationStyle, value: self.animate)
        .gesture(DragGesture().onEnded(dragCircle(value:)))
        
    }
    
    func centerCircle(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let xOffset = vector.dx
        let yOffset = vector.dy
        
        withAnimation(Animation.linear(duration: 0.1)) { self.circleXOffset = xOffset; self.circleYOffset = yOffset }
        
    }
    
    func dragCircle(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let xOffset = vector.dx
        let yOffset = vector.dy
        
        withAnimation(Animation.linear(duration: 0.1)) { self.circleXOffset = xOffset; self.circleYOffset = yOffset }
        
    }
    
}
