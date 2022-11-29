//
//  Sources.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct Sources: View {
    
    @StateObject var viewModel: SourcesViewModel
    var api: SourcesAPI
    
    var body: some View {
        Group{
            if (viewModel.loading) {
                ProgressView()
            } else {
                List(viewModel.sourceList ?? [SourceModel]()) { source in
                    Group {
                        Text(source.id)
                        Text(source.shortName)
                    }
                }
            }
        }
//        .onAppear {
//            api.fetch()
//        }
    }
}


class SourcesViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var sourceList: [SourceModel]?
    
    func updateValues(_ alive: Bool, _ data: [SourceModel]?) {
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
