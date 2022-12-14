//
//  LightsBottomPanel.swift
//  MyCabin
//
//  Created by Lawless on 12/14/22.
//

import SwiftUI

struct LightsBottomPanel: View {
    
    @State var lights = [LightModel]()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(lights) { light in
                    
                    LightControl(light: light)
                        .background(Color.black)
                    
                } //: FOR EACH
            }
        }
    }
}

struct LightsBottomPanel_Previews: PreviewProvider {
    static var previews: some View {
        LightsBottomPanel()
    }
}
