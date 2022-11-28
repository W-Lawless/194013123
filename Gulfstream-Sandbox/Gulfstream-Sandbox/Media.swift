//
//  Media.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct Media: View {
    var body: some View {
        Text("Monitors")
        ViewFactories.buildMonitorsView()
    }
}

struct Media_Previews: PreviewProvider {
    static var previews: some View {
        Media()
    }
}
