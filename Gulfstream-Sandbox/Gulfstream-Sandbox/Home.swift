//
//  Home.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct Home: View {
    
    var navCallback: (_ route: MenuRouter) -> () = { _ in }
    
    var body: some View {
        
        Spacer()
        
        Button("Lights") {
            print("clicked")
            navCallback(.lights)
        }
        
        Spacer()
        
        Button("Shades") {
            print("clicked")
            navCallback(.shades)
        }
        
        Spacer()
        
        Button("Seats") {
            print("clicked")
            navCallback(.seats)
        }
        
        Spacer()
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
