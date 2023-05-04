//
//  Sources.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct Sources: View {
    
    @StateObject var viewModel: SourcesViewModel
    
    var body: some View {
        Group{
            
            List(viewModel.sourceList ?? [SourceModel]()) { source in
                Group {
                    Text(source.id)
                    Text(source.shortName)
                }
            }
        }
    }
}


class SourcesViewModel: ObservableObject, GCMSViewModel {
    
    @Published var sourceList: [SourceModel]?
    
    func updateValues(_ data: [Codable]) {
        self.sourceList = data as? [SourceModel]
    }
    
}

struct Sources_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.buildSourcesView()
    }
}
