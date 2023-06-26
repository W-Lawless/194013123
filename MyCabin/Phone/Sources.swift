//
//  Sources.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

//TODO: - Remove Static References
struct Sources: View {
    
    @ObservedObject var viewModel: SourcesViewModel
    
    var body: some View {
        HStack(spacing:10) {
            
            ForEach(viewModel.sourceTypes, id: \.id) { sourceType in
                
                Button {
                    print("clicked!")
                } label: {
                    
                    VStack(spacing: 4) {
                        Image(sourceType.icon.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                        Text(sourceType.name)
                            .foregroundColor(.white)
                            .font(.system(size: 11))
                    } //: VSTQ
                    .frame(width: 88, height: 88)
                    .overlay (
                        RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 1).frame(width: 86, height: 86)
                    )
                    .hapticFeedback(feedbackStyle: .medium) { _ in
                        NavigationFactory.rootTabCoordinator.goToWithParams(
                            ViewFactory.buildSourceListView(sourceType.id)
                        )
                    }
                    
                } //: BTN
                .accessibilityIdentifier(sourceType.id.rawValue)
                
            } //: FOREACH
            
        } //: HSTQ
        .padding(.horizontal, 8)
        
    }

}

struct SourceList: View {
    
    @AppStorage("SelectedMonitor") var selectedMonitor: String = ""
    let sources: SourcesViewModel
    var filter: SourceTypes
    
    var body: some View {
        
        List {
            
            ForEach(sources.sourceList ?? [SourceModel](), id: \.id) { source in
                
                if(source.type == filter.rawValue) {

                    Button {
                        StateFactory.mediaViewModel.updateSelectedSource(source: source)
                        StateFactory.mediaViewModel.assignSourceToMonitor(source: source)
                        StateFactory.mediaViewModel.changeViewIntent(.selectSpeakerOutput)
                        StateFactory.mediaViewModel.clearSelection()
                        NavigationFactory.rootTabCoordinator.dismiss()
                    } label: {
                        Text(source.name)
                    } //: BTN
                    .accessibilityIdentifier(source.id)
                    
                } //: CONDITIONAL
                
            } //: FOREACH
            
        } //: LIST
        .padding(.horizontal, 8)
        
    }
    
}


class SourcesViewModel: ObservableObject, GCMSViewModel {
    
    @Published var sourceList: [SourceModel]?
    @Published var sourceTypes = [SourceType]()
    
    func updateValues(_ data: [Codable]) {
        self.sourceList = data as? [SourceModel]
    }
    
    func updateSourceTypes(_ set: Set<SourceType>) {
        set.forEach { sourceType in
            self.sourceTypes.append(sourceType)
        }
        self.sourceTypes.sort { $0.name < $1.name }
    }
    
}
