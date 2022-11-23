//
//  Shades.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import SwiftUI

struct Shades: View {
    
    @ObservedObject var viewModel: ShadesViewModel
    var api: ShadesAPI
    
    var body: some View {
        TabView{
            
            List(viewModel.shadeList ?? [ShadeModel]()) { shade in
                Button("OPEN \(shade.id.lowercased())") {
                    api.commandShade(shade: shade, cmd: .OPEN)
                }
            }//: LIST
            
            List(viewModel.shadeList ?? [ShadeModel]()) { shade in
                Button("SHEER \(shade.id.lowercased())") {
                    api.commandShade(shade: shade, cmd: .SHEER)
                }
            }//: LIST
            
            List(viewModel.shadeList ?? [ShadeModel]()) { shade in
                Button("CLOSE \(shade.id.lowercased())") {
                    api.commandShade(shade: shade, cmd: .CLOSE)
                }
            }//: LIST
        }
        .tabViewStyle(.page)
        .onAppear {
            api.fetch()
        }
    }
}

class ShadesViewModel: ObservableObject {

    @Published var shadeList: [ShadeModel]?
    
    func updateValues(_ alive: Bool, _ data: [ShadeModel]?) {
        if let data = data {
            self.shadeList = data
        }
    }
    
}

struct Shades_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildShadesView()
    }
}
