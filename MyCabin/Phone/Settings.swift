//
//  Settings.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import SwiftUI

struct Settings: View {
    
    @AppStorage("someSetting") var address: String = "http://10.0.0.41"

    var body: some View {
        VStack {
            Text("SETTINGS")
            TextField("Some Setting:", text: $address)
            Button("Save") {
                
            }
        }
        .onAppear {
            AppFactory.fetchAll()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
