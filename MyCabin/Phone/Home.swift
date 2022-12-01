//
//  Home.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct Home: View {
    
//    var navCallback: (_ route: MenuRouter) -> () = { _ in }
    let navigation: HomeMenuCoordinator
    @State var someSetting: String = (UserDefaults.standard.string(forKey: "someSetting") ?? "DefaultValue")
    
    var body: some View {
        
        Group {
            HStack(alignment: .center, spacing: 72) {
                
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "lightbulb")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .onTapGesture {
                            navigation.goTo(.lights)
                        }
                    Text("Lights")
                } //: VSTQ
                
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "uiwindow.split.2x1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Button("Shades") {
                        print("clicked")
                        navigation.goTo(.shades)
                    }
                    .foregroundColor(.white)
                } //: VSTQ
            } //:HSTQ
            .frame(height:120)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            
            
            HStack(alignment: .center, spacing: 32) {
                
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "thermometer.sun")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Button("Temperature") {
                        navigation.goTo(.climate)
                    }
                    .foregroundColor(.white)
                } //: VSTQ
                .frame(width: 98)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "s.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Button("Seats") {
                        print("clicked")
                        navigation.goTo(.seats)
                    }
                    .foregroundColor(.white)
                } //:VSTQ
                .frame(width: 98)
            } //:HSTQ
            .frame(height:120)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            
            
            HStack(alignment: .center, spacing: 72) {
                
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "list.bullet.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Button("Presets") {
                        navigation.goTo(.presets)
                    }
                    .foregroundColor(.white)
                } //: VSTQ
                
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    Button("Settings") {
                        navigation.goTo(.settings)
                    }
                    .foregroundColor(.white)
                } //: VSTQ
            } //: HSTQ
            .frame(height:120)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 2)
        )
        //        Curves()
        
//        Pulse()
        
//        VStack { //: VSTQ 1
//            Image(systemName: "house.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(height: 72)
//                .hapticFeedback()
//        } //VSTQ: 1
//        .frame(height: 300)
//        .padding(.horizontal, 24)
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}


//MARK: - Custom Curves

struct Curves: View {
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 108)
                
            } //: ZSTQ
            .background(Color.secondary)
            
        } //: VSTQ
        
    }
    
}


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
