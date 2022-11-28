//
//  Sources.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct Sources: View {
    
    @StateObject var viewModel: SourceViewModel
    var api: SourceAPI
    
    var body: some View {
        Group{
            if (viewModel.loading) {
                ProgressView()
            } else {
                List(viewModel.sourceList ?? [SourceModel]()) { source in
                    Group {
                        Text(source.id)
                        Text(source.shortName)
//                        Button("Power On") {
//                            api.togglePower(monitor, cmd: true)
//                        }
//                        Button("Power Off") {
//                            api.togglePower(monitor, cmd: false)
//                        }
                    }
                }
            }
        }.onAppear {
            api.fetch()
        }
    }
}


class SourceViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var sourceList: [SourceModel]?
    
    func updateValues(_ alive: Bool, _ data: [SourceModel]?) {
        print("updating values with data")
        self.loading = !alive
        if let data = data {
            self.sourceList = data
        }
    }
    
}

struct Sources_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildSourcesView()
    }
}
