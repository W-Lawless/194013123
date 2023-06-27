//
//  Routers.swift
//  MyCabin
//
//  Created by Lawless on 12/1/22.
//

import SwiftUI
import UIKit

enum MenuRouter {
    
    case lights
    case shades
    case seats
    case climate
    case presets
    case settings
    case sourceList
//    case plane
    
    var transition: NavigationTranisitionStyle {
        switch self {
        case .lights:
            return .presentFullscreen(presentation: UIModalPresentationStyle.fullScreen)
        case .shades:
            return .push(presentation: UIModalPresentationStyle.automatic)
        case .seats:
            return .presentModally(presentation: UIModalPresentationStyle.pageSheet)
        default:
            return .push(presentation: UIModalPresentationStyle.automatic)
        }
    }

}

protocol NavigationRouter {
    var transition: NavigationTranisitionStyle { get }
    func view() -> UIViewController
}

enum NavigationTranisitionStyle {
    case push(presentation: UIModalPresentationStyle)
    case presentModally(presentation: UIModalPresentationStyle)
    case presentFullscreen(presentation: UIModalPresentationStyle)
}
