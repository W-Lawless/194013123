//
//  Settings.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import SwiftUI

struct Settings: View {
    
    @State var someSetting: String = (UserDefaults.standard.string(forKey: "someSetting") ?? "DefaultValue")
    
    var body: some View {
        Text("SETTINGS")
        TextField("Some Setting:", text: $someSetting)
        Button("Save") {
            @UserDefaultUtil("someSetting", defaultValue: "http://10.0.0.41")
            var abc: String
            
            abc = self.someSetting
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
