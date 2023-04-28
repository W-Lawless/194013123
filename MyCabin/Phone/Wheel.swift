//
//  Wheel.swift
//  MyCabin
//
//  Created by Lawless on 4/22/23.
//
import SwiftUI

struct RotatingWheel: View {
    @State var progress1 = 0.75
    @State var progress2 = 37.5
    @State var progress3 = 7.5
    
    var body: some View {
        ZStack {
            Color(hue: 0.58, saturation: 0.06, brightness: 1.0)
                .edgesIgnoringSafeArea(.all)

            VStack {
                CircularSliderView(value: $progress1)
                    .frame(width:250, height: 250)
                
                HStack {
                    CircularSliderView(value: $progress2, in: 32...50)

                    CircularSliderView(value: $progress3, in: 0...100)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RotatingWheel()
    }
}

struct CircularSliderView: View {
    @Binding var progress: Double

    @State private var rotationAngle = Angle(degrees: 0)
    private var minValue = 0.0
    private var maxValue = 1.0
    
    init(value progress: Binding<Double>, in bounds: ClosedRange<Int> = 0...1) {
        self._progress = progress
        
        self.minValue = Double(bounds.first ?? 0)
        self.maxValue = Double(bounds.last ?? 1)
        self.rotationAngle = Angle(degrees: progressFraction * 360.0)
    }
    
    private var progressFraction: Double {
        return ((progress - minValue) / (maxValue - minValue))
    }
    
    private func changeAngle(location: CGPoint) {
        // Create a Vector for the location (reversing the y-coordinate system on iOS)
        let vector = CGVector(dx: location.x, dy: -location.y)
        
        // Calculate the angle of the vector
        let angleRadians = atan2(vector.dx, vector.dy)
        
        // Convert the angle to a range from 0 to 360 (rather than having negative angles)
        let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
        
        // Update slider progress value based on angle
        progress = ((positiveAngle / (2.0 * .pi)) * (maxValue - minValue)) + minValue
        rotationAngle = Angle(radians: positiveAngle)
    }
    
    var body: some View {
        GeometryReader { gr in
            let radius = (min(gr.size.width, gr.size.height) / 2.0) * 0.9
            let sliderWidth = radius * 0.1
            
            VStack(spacing:0) {
                ZStack {
                    Circle()
                        .stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9),
                                style: StrokeStyle(lineWidth: sliderWidth))
                        .overlay(
                            Text("\(progress, specifier: "%.2f")")
                                .font(.system(size: radius * 0.6, weight: .bold, design:.rounded))
                        )
                    // uncomment to show tick marks
                    //Circle()
                    //    .stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.6),
                    //            style: StrokeStyle(lineWidth: sliderWidth * 0.75,
                    //                               dash: [2, (2 * .pi * radius)/24 - 2]))
                    //    .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .trim(from: 0, to: progressFraction)
                        .stroke(Color(hue: 0.0, saturation: 0.5, brightness: 0.9),
                                style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round)
                        )
                        .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: (sliderWidth * 0.3))
                        .frame(width: sliderWidth, height: sliderWidth)
                        .offset(y: -radius)
                        .rotationEffect(rotationAngle)
                        .gesture(
                            DragGesture(minimumDistance: 0.0)
                                .onChanged() { value in
                                    changeAngle(location: value.location)
                                }
                        )
                }
                .frame(width: radius * 2.0, height: radius * 2.0, alignment: .center)
                .padding(radius * 0.1)
            }
            
            .onAppear {
                self.rotationAngle = Angle(degrees: progressFraction * 360.0)
            }
        }
    }
}

//struct RotatingWheel: View {
////    @State private var rotationAngle: Double = 0
//    @Binding var progress: Double
//
//    @State private var rotationAngle = Angle(degrees: 0)
//    @State private var previousAngle = Angle(degrees: 0)
//
//    @State private var previousIndex: Int = -1
//
//    private let numberOfButtons: Int = 8
//    private var minValue = 0.0
//    private var maxValue = 1.0
//
//    var body: some View {
//        ZStack {
//            ForEach(0..<8) { index in
//                Button(action: {
//                    print("Button \(index) tapped")
//                }) {
//                    Circle()
//                        .fill(Color.blue)
//                        .frame(width: 50, height: 50)
//                }
//                .offset(x: 100)
//                .rotationEffect(.degrees(Double(index) * 360 / Double(numberOfButtons)), anchor: .center)
//            }
//        }
//        .frame(width:300, height:200)
//        .border(.red, width: 1)
//        .rotationEffect(rotationAngle, anchor: .center)
//        .gesture(
//            DragGesture(minimumDistance: 0)
//                .onChanged { value in
//                    print("value has changed", value)
//                    let angle = angleBetweenPoints(value.startLocation, value.location)
//                    rotationAngle = previousAngle + angle
//
//                    let currentIndex = Int(((360 - rotationAngle).truncatingRemainder(dividingBy: 360)) / (360 / Double(numberOfButtons)))
//
//                    if currentIndex != previousIndex {
//                        generateHapticFeedback()
//                        previousIndex = currentIndex
//                    }
//                }
//                .onEnded { value in
//                    previousAngle = rotationAngle
//                }
//        )
//
//    }
//
//    private func angleBetweenPoints(_ startPoint: CGPoint, _ endPoint: CGPoint) -> Double {
//        let dx = endPoint.x - startPoint.x
//        let dy = endPoint.y - startPoint.y
//        return Double(atan2(dy, dx)) * 180 / Double.pi
//    }
//
//    private func generateHapticFeedback() {
//        let generator = UISelectionFeedbackGenerator()
//        generator.selectionChanged()
//    }
//
//}
//
//struct ContentView: View {
//    var body: some View {
//        RotatingWheel()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
