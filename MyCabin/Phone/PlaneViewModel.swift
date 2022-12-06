//
//  PlaneViewModel.swift
//  MyCabin
//
//  Created by Lawless on 12/6/22.
//

import Foundation

class PlaneViewModel: ObservableObject {
    @Published var plane: Plane!
    
    func updateValues(_ alive: Bool, _ data: Plane?) {
        if let data = data {
            self.plane = data
        }
    }
}
