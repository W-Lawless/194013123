//
//  ConfirmationSubView.swift
//  MyCabin
//
//  Created by Lawless on 7/5/23.
//

import SwiftUI

struct ConfirmationSubView: View {
    
    let confirmationHandler: () -> ()
    
    var body: some View {
        Button {
            confirmationHandler()
        } label: {
            Text("Confirm")
        }
    }
}
