//
//  LoadAll.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import UIKit
import SwiftUI
import Combine


final class PlaneFactory {
    //: State Handling
    ///Cabin Connection
    static let cabinConnectionPublisher = CurrentValueSubject<Bool, Never>(false)
    static var cabinConnectionSubscriptions = Set<AnyCancellable>()
    static var apiSubscriptions = Set<AnyCancellable>()
    static var cancelTokens = Set<AnyCancellable>()
    
    static let cabinAPI = CabinAPI()
    ///Access Levels
    static let accessAPI = AccessAPI()
    ///Plane Map
    static let planeViewModel = PlaneViewModel()
    
    static var elementsAPI = ElementsAPI(viewModel: planeViewModel)
    
    //Aggregate API
    static var planeElements: PlaneMap?
    
    //Menus
    
    static func buildPlaneSchematic<AViewModel: ViewModelWithSubViews>(topLevelViewModel: AViewModel, options: PlaneSchematicDisplayMode) -> PlaneSchematic<AViewModel> {
        let view = PlaneSchematic<AViewModel>(topLevelViewModel: topLevelViewModel, viewModel: planeViewModel, navigation: NavigationFactory.homeMenuCoordinator, options: options)
        return view
    }
    
    static func connectToPlane() {

        Task{
            do {
                try await FileCacheUtil.loadAllCaches()
            } catch {
                print("Cache failed to load")
                await PlaneFactory.elementsAPI.fetch()
            }
//            await areasAPI.mapPlane()
//            accessAPI.registerDevice()
        }

        
//        ///Non Caching
//        cabinClimateAPI.fetch()
//        flightAPI.fetch()
//        weatherAPI.fetch()
    }
}

final class ViewFactory {
    
    static let volumeMenu = UIHostingController(rootView: buildVolumeView())
    static let loadingView = UIHostingController(rootView: Loading(api: PlaneFactory.cabinAPI))
    
    static func buildMenuOverview() -> Home {
        let view = Home(navigation: NavigationFactory.homeMenuCoordinator)
        return view
    }
    
    static func buildLightsMenu() -> Lights {
        let view = Lights()
        return view
    }
            
    static func buildSeatSelection() -> SeatSelection {
        let view = SeatSelection(viewModel: StateFactory.seatsViewModel, api: StateFactory.seatsAPI)
        return view
    }
    
    static func buildShadesView() -> Shades {
        let view = Shades(viewModel: StateFactory.shadesViewModel, api: StateFactory.shadesAPI)
        return view
    }
    
    
    static func buildCabinClimateView() -> CabinClimate {
        let view = CabinClimate(viewModel: StateFactory.climateViewModel, api: StateFactory.cabinClimateAPI)
        return view
    }
    
    // Media
    
    static func buildMonitorsView() -> Monitors {
        let view = Monitors(viewModel: StateFactory.monitorsViewModel, api: StateFactory.monitorsAPI)
        return view
    }
    
    static func buildSourcesView() -> Sources {
        let view = Sources(viewModel: StateFactory.sourcesViewModel, api: StateFactory.sourcesAPI)
        return view
    }
    
    static func buildSpeakersView() -> Speakers {
        let view = Speakers(viewModel: StateFactory.speakersViewModel, api: StateFactory.speakersAPI)
        return view
    }
    
    
    static func buildVolumeView() -> Volume {
        let view = Volume(viewModel: StateFactory.speakersViewModel, api: StateFactory.speakersAPI)
        return view
    }
    
    //Flight
    
    static func buildFlightInfo() -> FlightInfo {
        let view = FlightInfo(viewModel: StateFactory.flightViewModel, api: StateFactory.flightAPI)
        return view
    }
    
    static func buildWeatherView() -> Weather {
        let view = Weather(viewModel: StateFactory.weatherViewModel, api: StateFactory.weatherAPI)
        return view
    }
    
}

//MARK: - Navigation

final class NavigationFactory {

    //Navigation
    static let homeMenuCoordinator = HomeMenuCoordinator()
    
    static func buildRootTabNavigation() -> RootTabCoordinator {
        let coordinator = RootTabCoordinator()
        coordinator.navigationController.tabBar.tintColor = .white
        
        let tabOne = buildHomeMenu()
        let tabTwo = UIHostingController(rootView: MediaTab())
        let tabThree = UIHostingController(rootView: FlightTab())
        
        tabOne.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(systemName: "play"), selectedImage: UIImage(systemName: "play.fill"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane.circle"))
     
        
        coordinator.start(subviews: [tabOne.navigationController,tabTwo,tabThree])
        return coordinator
    }
    
    static func buildHomeMenu() -> HomeMenuCoordinator {
        
        let rootMenuView = UIHostingController(rootView: ViewFactory.buildMenuOverview())
        rootMenuView.title = "Home"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        //        navigationBarAppearance.backgroundColor = .systemIndigo
        rootMenuView.navigationItem.standardAppearance = navigationBarAppearance
        rootMenuView.navigationItem.compactAppearance = navigationBarAppearance
        rootMenuView.navigationItem.scrollEdgeAppearance = navigationBarAppearance

//        let planeMenu = UIHostingController(rootView: AppFactory.buildPlaneSchematic())
//        planeMenu.title = "Select your seat"
        
        let volumeMenu = UIHostingController(rootView: ViewFactory.buildVolumeView())
        volumeMenu.title = "Volume"
        
        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(volumeClick))
        let icon = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(attendantClick))
        rootMenuView.navigationItem.rightBarButtonItems = [volume, icon]
        
        homeMenuCoordinator.start(subviews: [rootMenuView])
        
        return homeMenuCoordinator
    }
    
    @objc static func volumeClick() {
        homeMenuCoordinator.navigationController.present(ViewFactory.volumeMenu, animated: true)
    }
    
    @objc static func attendantClick() {
//        homeMenuCoordinator.navigationController.present(UIHostingController(rootView: AppFactory.buildPlaneSchematic()), animated: true)
    }
}

//MARK: - ViewModels & API Adaptors

final class StateFactory {

    //Views
        ///Lights
    static let lightsViewModel = LightsViewModel()
    static let lightsAPI = LightsAPI(viewModel: lightsViewModel)
        ///Shades
    static let shadesViewModel = ShadesViewModel()
    static let shadesAPI = ShadesAPI(viewModel: shadesViewModel)
        ///Seats
    static let seatsViewModel = SeatsViewModel()
    static let seatsAPI = SeatsAPI(viewModel: seatsViewModel)
        ///Climate
    static let climateViewModel = CabinClimateViewModel()
    static let cabinClimateAPI = CabinClimateAPI(viewModel: climateViewModel)
        
    
    //Media
        ///Monitors
    static let monitorsViewModel = MonitorsViewModel()
    static let monitorsAPI = MonitorsAPI(viewModel: monitorsViewModel)
        ///Speakers
    static let speakersViewModel = SpeakersViewModel()
    static let speakersAPI = SpeakersAPI(viewModel: speakersViewModel)
        ///Sources
    static let sourcesViewModel = SourcesViewModel()
    static let sourcesAPI = SourcesAPI(viewModel: sourcesViewModel)
    
    //Flight
        ///Flight Info
    static let flightViewModel = FlightViewModel()
    static let flightAPI = FlightAPI(viewModel: flightViewModel)
        ///Weather
    static let weatherViewModel = WeatherViewModel()
    static let weatherAPI = WeatherAPI(viewModel: weatherViewModel)

    
    
    //MARK: - Fetch Methods
    ///TODO: ASYNCSEQUENCE / ASYNCSTREAM
    
}
