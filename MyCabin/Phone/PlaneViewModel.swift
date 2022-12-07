//
//  PlaneViewModel.swift
//  MyCabin
//
//  Created by Lawless on 12/6/22.
//

import Foundation

class MapViewModel: ObservableObject {
    @Published var planeMap: PlaneMap!
    
    func updateValues(_ alive: Bool, _ data: PlaneMap?) {
        if let data = data {
            self.planeMap = data
        }
    }
}

class PlaneViewModel: ObservableObject {
    @Published var plane: Plane!
    
    func updateValues(_ alive: Bool, _ data: Plane?) {
        if let data = data {
            self.plane = data
        }
    }
}


class PlaneViewCoordinates: ObservableObject {
    
    @Published var containerViewHeight: CGFloat = 0
    @Published var containerViewWidth: CGFloat = 0
    @Published var containerWidthUnit: CGFloat = 0
    @Published var containerHeightUnit: CGFloat = 0
    
}
