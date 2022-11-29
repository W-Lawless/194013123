//
//  MapInPlace.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation

extension Array {
    mutating func mapInPlace(_ x: (inout Element) -> ()) {
        for i in indices {
            x(&self[i])
        }
    }
}
