//
//  UI+.swift
//  MyCabin
//
//  Created by Lawless on 5/4/23.
//

import Foundation

protocol GCMSViewModel {
    func updateValues(_ data: [Codable])
}

protocol ParentViewModel: ViewWithSubViews & ObservableObject {}

protocol ViewWithSubViews {
    func showSubView(forID: String)
}
