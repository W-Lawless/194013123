//
//  ContentView.swift
//  wearable Watch App
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct CallAttendant: View {
    
    var phone = PhoneConnection()
//    @State var message = ""
    
    @ObservedObject var api: SeatsApi

    
    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Button("Call Attendant") {
//                self.phone.sendToPhone(data: ["callAttendant": "mySeat"])
//            }
//        }
//        .padding()
        
        List(api.seatList ?? [Seat]()) { seat in
            Button(seat.id) {
                Task {
                    await api.call(seat: seat)
                }
            }
        } //: LIST
        .task() {
            await api.getSeats()
        }
        
    }
}

struct CallAttendant_Previews: PreviewProvider {
    static var previews: some View {
        CallAttendant(api: SeatsApi())
    }
}
