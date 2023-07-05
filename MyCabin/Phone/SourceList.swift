//
//  SourceList.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

struct SourceList: View {
    
    let sources: MediaViewModel
    var filter: SourceTypes
    
    let selectionCallback: (SourceModel) -> ()
    
    var body: some View {
        
        List {
            
            ForEach(sources.sourceList, id: \.id) { source in
                
                if(source.type == filter.rawValue) {
                
                    Button {
                        selectionCallback(source)
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
