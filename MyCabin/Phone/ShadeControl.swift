//
//  ShadeControl.swift
//  MyCabin
//
//  Created by Lawless on 12/20/22.
//

import SwiftUI

struct ShadeControl: View {
    
    @AppStorage("CurrentSeat") var currentSeat: String = ""
    @State var opened: Bool = false
    @State var sheered: Bool = false
    @State var closed: Bool = false
    @State var shade: ShadeModel = ShadeModel(id: "1", name: "window", side: "left", rect: RenderCoordinates(x: 0.0, y: 0.0, w: 0.0, h: 0.0, r: 0.0), sub: [], assoc: [])
    
    var body: some View {
        
        HStack {
            
            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(opened ? Color.green : Color.black)
                        .frame(width:48, height: 50)
                        .overlay (
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                Text("OPEN")
                    .font(.caption2)
            }
            .frame(width: 64)
            .hapticFeedback(feedbackStyle: .rigid) {
                opened = true
                sheered = false
                closed = false
                
                StateFactory.apiClient.commandShade(shade: shade, cmd: .OPEN)
            } //: VSTQ

            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(sheered ? Color.green : Color.black)
                        .frame(width:48, height: 50)
                        .overlay (
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                Text("SHEER")
                    .font(.caption2)
            }
            .frame(width: 64)
            .hapticFeedback(feedbackStyle: .rigid) {
                opened = false
                sheered = true
                closed = false
                
                StateFactory.apiClient.commandShade(shade: shade, cmd: .SHEER)
            } //: VSTQ

            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(closed ? Color.green : Color.black)
                        .frame(width:48, height: 50)
                        .overlay (
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                Text("CLOSE")
                    .font(.caption2)
            }
            .frame(width: 64)
            .hapticFeedback(feedbackStyle: .rigid) {
                closed = true
                opened = false
                sheered = false
                
                StateFactory.apiClient.commandShade(shade: shade, cmd: .CLOSE)
            } //: VSTQ

        } //: HSTQ
        .padding(18)
        
    } //: BODY
    
    
    private func getShadesForSeat() {
        let target = PlaneFactory.planeElements?.allSeats.filter { seat in
            return seat.id == currentSeat
        }
    }
}

struct ShadeControl_Previews: PreviewProvider {
    static var previews: some View {
        let shade = ShadeModel(id: "1", name: "window", side: "left", rect: RenderCoordinates(x: 0.0, y: 0.0, w: 0.0, h: 0.0, r: 0.0), sub: [], assoc: [])
        ShadeControl(shade: shade)
            .previewLayout(.sizeThatFits)
    }
}
