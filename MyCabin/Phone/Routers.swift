//
//  Routers.swift
//  MyCabin
//
//  Created by Lawless on 12/1/22.
//

import SwiftUI
import UIKit

enum MenuRouter: NavigationRouter {
    
    case lights
    case shades
    case seats
    case climate
    case presets
    case settings
    case plane
    
    var transition: NavigationTranisitionStyle {
        switch self {
        case .lights:
            return .push
        case .shades:
            return .push
        case .seats:
            return .presentModally
        default:
            return .push
        }
    }
    
    func view() -> UIViewController {
        switch self {
        case .lights:
           return UIHostingController(rootView: AppFactory.buildLightsView())
        case .shades:
            return UIHostingController(rootView: AppFactory.buildShadesView())
        case .seats:
            return UIHostingController(rootView: AppFactory.buildSeatSelection())
        case .climate:
            return UIHostingController(rootView: AppFactory.buildCabinClimateView())
        case .presets:
            return UIHostingController(rootView: Presets())
        case .settings:
            return UIHostingController(rootView: Settings())
        case .plane:
            return UIHostingController(rootView: AppFactory.buildPlaneSchematic())
        }
    }
}

protocol NavigationRouter {
    var transition: NavigationTranisitionStyle { get }
    func view() -> UIViewController
}

enum NavigationTranisitionStyle {
    case push
    case presentModally
    case presentFullscreen
}
