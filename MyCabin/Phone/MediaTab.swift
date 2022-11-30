//
//  Media.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct MediaTab: View {
    var body: some View {
        TabView {
            ViewFactories.buildMonitorsView()
            ViewFactories.buildSourcesView()
            ViewFactories.buildSpeakersView()
        }
        .tabViewStyle(.page)
    }
}

struct Media_Previews: PreviewProvider {
    static var previews: some View {
        MediaTab()
    }
}
