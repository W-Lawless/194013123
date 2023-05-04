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
    static var cancelTokens = Set<AnyCancellable>()
    
    static let cabinEndpoint = Endpoint<EndpointFormats.Head, EmptyResponse>(path: .ping)
    static let cabinAPI = CabinAPI(endpoint: cabinEndpoint) { _ in }
    ///Access Levels
    static let accessAPI = AccessAPI()
    ///Plane Map
    static var planeViewModel = PlaneViewModel()
    
    static var elementsAPI = ElementsAPI(viewModel: planeViewModel)
    
    //Aggregate API
    static var planeElements: PlaneMap?
    
    //Menus
    
    static func buildPlaneSchematic<T: ParentViewModel>(topLevelViewModel: T, options: PlaneSchematicDisplayMode) -> PlaneSchematic<T> {
        let view = PlaneSchematic<T>(topLevelViewModel: topLevelViewModel, viewModel: planeViewModel, navigation: NavigationFactory.homeMenuCoordinator, options: options, selectedZone: nil)
        return view
    }
    
    static func connectToPlane() {

        Task(priority: .high) {
            do {
                try await FileCacheUtil.loadAllCaches()
            } catch {
                print("Cache failed to load")
                await PlaneFactory.elementsAPI.fetch()
            }
            StateFactory.apiClient.fetchClimateControllers()
        }
        
        //            accessAPI.registerDevice()
//        ///Non Caching
//        flightAPI.fetch()
//        weatherAPI.fetch()
    }
    
    static func seatIconCallback(displayOptions: PlaneSchematicDisplayMode, seatID: String) {
        
        switch displayOptions {
        case .onlySeats:
            UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                NavigationFactory.homeMenuCoordinator.dismiss()
            }
        case .showLights:
            StateFactory.lightsViewModel.showSubView(forID: seatID)
        default:
            break
        } //: SWITCH
    }
    
    static func shadeIconCallback(shade: ShadeModel) {
        StateFactory.shadesViewModel.showSubView(forID: shade.id)
        StateFactory.shadesViewModel.activeShade = shade
    }
}

final class ViewFactory {
    
    static let volumeMenu = UIHostingController(rootView: buildVolumeView())
    static let loadingView = UIHostingController(rootView: buildLoadingScreen())
    
    static func buildLoadingScreen() -> Loading {
        let startMonitor = PlaneFactory.cabinAPI.monitor.startMonitor
        let monitorCallback = PlaneFactory.cabinAPI.monitorCallback
        let stopMonitor = PlaneFactory.cabinAPI.monitor.stopMonitor
        
        let view = Loading(startMonitor: startMonitor, monitorCallback: monitorCallback, stopMonitor: stopMonitor)
        
        return view
    }
    
    static func buildMenuOverview() -> Home {
        let view = Home(navigateTo: NavigationFactory.homeMenuCoordinator.goTo)
        return view
    }
    
    static func buildLightsMenu() -> Lights {
        let view = Lights()
        return view
    }
            
    static func buildSeatSelection() -> SeatSelection {
        let view = SeatSelection(viewModel: StateFactory.seatsViewModel)
        return view
    }
    
    static func buildShadesView() -> Shades {
        let view = Shades(viewModel: StateFactory.shadesViewModel)
        return view
    }
    
    
    static func buildCabinClimateView() -> CabinClimate {
        let view = CabinClimate(viewModel: StateFactory.climateViewModel)
        return view
    }
    
    // Media
    
    static func buildMonitorsView() -> Monitors {
        let view = Monitors(viewModel: StateFactory.monitorsViewModel)
        return view
    }
    
    static func buildSourcesView() -> Sources {
        let view = Sources(viewModel: StateFactory.sourcesViewModel)
        return view
    }
    
    static func buildSpeakersView() -> Speakers {
        let view = Speakers(viewModel: StateFactory.speakersViewModel)
        return view
    }
    
    
    static func buildVolumeView() -> Volume {
        let view = Volume(viewModel: StateFactory.speakersViewModel)
        return view
    }
    
    //Flight
    
    static func buildFlightInfo() -> FlightInfo {
        
        let viewModel = StateFactory.flightViewModel
        let startMonitor = StateFactory.flightAPI.monitor.startMonitor
        let monitorCallback = StateFactory.flightAPI.monitorCallback
        let stopMonitor = StateFactory.flightAPI.monitor.stopMonitor
        
        let view = FlightInfo(viewModel: viewModel , startMonitor: startMonitor, monitorCallback: monitorCallback, stopMonitor: stopMonitor)
        
        return view
    }
    
    static func buildWeatherView() -> Weather {
        
//        let viewModel = StateFactory.weatherViewModel
//        let startMonitor = StateFactory.weatherAPI.monitor.startMonitor
//        let monitorCallback = StateFactory.weatherAPI.monitorCallback
//        let stopMonitor = StateFactory.weatherAPI.monitor.stopMonitor
        
        let view = Weather(viewModel: StateFactory.weatherViewModel)
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
    
    static var apiClient = GCMSClient()
    
    //Views
    static let lightsViewModel = LightsViewModel()
    ///Endpoint<EndpointFormats.Get, LightModel>(path: .lights)

    ///Shades
    static let shadesViewModel = ShadesViewModel()
    ///Endpoint<EndpointFormats.Get, ShadeModel>(path: .shades)
    
    ///Seats
    static let seatsViewModel = SeatsViewModel()
    ///Endpoint<EndpointFormats.Get, SeatModel>(path: .seats)
    
    ///Climate
    static let climateViewModel = CabinClimateViewModel()
    ///Endpoint<EndpointFormats.Get, ClimateControllerModel>(path: .climate)
        
    //Media
        ///Monitors
    static let monitorsViewModel = MonitorsViewModel()
    ///Endpoint<EndpointFormats.Get, MonitorModel>(path: .monitors)
        ///Speakers
    static let speakersViewModel = SpeakersViewModel()
    ///Endpoint<EndpointFormats.Get, SpeakerModel>(path: .speakers)
        ///Sources
    static let sourcesViewModel = SourcesViewModel()
    ///Endpoint<EndpointFormats.Get, SourceModel>(path: .sources)
    
    //Flight
    static let flightViewModel = FlightViewModel()
    
    static var flightEndpoint = Endpoint<EndpointFormats.Get, FlightModel>(path: .flightInfo)
    
    static let flightAPI = RealtimeAPI(endpoint: flightEndpoint) { shades in
        StateFactory.flightViewModel.updateValues(shades)
    }
    
    //Weather
    static let weatherViewModel = WeatherViewModel()
    
    static var weatherEndpoint = Endpoint<EndpointFormats.Get, WeatherModel>(path: .weather)
    
    static let weatherAPI = RealtimeAPI(endpoint: weatherEndpoint) { weather in
        StateFactory.weatherViewModel.updateValues(weather)
    }

    
    
    //MARK: - Fetch Methods
    ///TODO: ASYNCSEQUENCE / ASYNCSTREAM
    
}
