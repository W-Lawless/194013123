//
//  Routers.swift
//  MyCabin
//
//  Created by Lawless on 12/1/22.
//

import SwiftUI
import UIKit

enum MenuRouter: NavigationRouter {
    
    case toplevel
    case lights
    case shades
    case seats
    case climate
    case presets
    case settings
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
    
    func view() -> UIViewController {
        switch self {
        case .toplevel:
            return UIHostingController(rootView: ViewFactory.buildMenuOverview())
        case .lights:
           return UIHostingController(rootView: ViewFactory.buildLightsMenu())
        case .shades:
            return UIHostingController(rootView: ViewFactory.buildShadesView())
        case .seats:
            return UIHostingController(rootView: ViewFactory.buildSeatSelection())
        case .climate:
            return UIHostingController(rootView: ViewFactory.buildCabinClimateView())
        case .presets:
            return UIHostingController(rootView: Presets())
        case .settings:
            return UIHostingController(rootView: Settings())
//        case .plane:
//            return UIHostingController(rootView: AppFactory.buildPlaneSchematic())
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
