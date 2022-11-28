//
//  File.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation
import SwiftUI

enum Route {
    case loading
}

struct Navigator {
    static func navigate<T: View>(_ route: Route, content: () -> T) -> AnyView {
        switch route {
        case .loading:
            return AnyView(
                NavigationLink(destination: MediaTab()) {
                    content()
                }
            )
            
        }
    }
}
