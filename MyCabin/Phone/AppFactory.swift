//
//  LoadAll.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import UIKit
import SwiftUI
import Combine


final class AppFactory {
    
    //MARK: - Properties
    
    //: State Handling
        ///Cabin Connection
    static let cabinConnectionPublisher = CurrentValueSubject<Bool, Never>(false)
    static var cabinConnectionSubscriptions = Set<AnyCancellable>()
    static let cabinAPI = CabinAPI()
        ///Access Levels
    static let accessAPI = AccessAPI()
        ///Plane Map
    static let mapViewModel = MapViewModel()
    static let elementsAPI = ElementsAPI(viewModel: mapViewModel)
    static let planeViewModel = PlaneViewModel()
    static let areasAPI = AreasAPI(viewModel: planeViewModel)
    
    //: Menus
    //Navigation
    static let homeMenuCoordinator = HomeMenuCoordinator()
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

    //Auxillary Views
    static let loadingView = UIHostingController(rootView: Loading(api: cabinAPI))
    static let volumeMenu = UIHostingController(rootView: buildVolumeView())

    
    //MARK: - View Builders
    
    //Menus
    
    static func buildPlaneSchematic() -> PlaneSchematic {
        let view = PlaneSchematic(viewModel: planeViewModel, navigation: homeMenuCoordinator)
        return view
    }
    
    static func buildSeatSelection() -> SeatSelection {
        let view = SeatSelection(viewModel: seatsViewModel, api: seatsAPI)
        return view
    }
    
    static func buildShadesView() -> Shades {
        let view = Shades(viewModel: shadesViewModel, api: shadesAPI)
        return view
    }
    
    static func buildLightsView() -> Lights {
        let view = Lights(viewModel: lightsViewModel, api: lightsAPI, navigation: homeMenuCoordinator)
        return view
    }
    
    static func buildCabinClimateView() -> CabinClimate {
        let view = CabinClimate(viewModel: climateViewModel, api: cabinClimateAPI)
        return view
    }
    
    // Media
    
    static func buildMonitorsView() -> Monitors {
        let view = Monitors(viewModel: monitorsViewModel, api: monitorsAPI)
        return view
    }
    
    static func buildSourcesView() -> Sources {
        let view = Sources(viewModel: sourcesViewModel, api: sourcesAPI)
        return view
    }
    
    static func buildSpeakersView() -> Speakers {
        let view = Speakers(viewModel: speakersViewModel, api: speakersAPI)
        return view
    }
    
    
    static func buildVolumeView() -> Volume {
        let view = Volume(viewModel: speakersViewModel, api: speakersAPI)
        return view
    }
    
    //Flight
    
    static func buildFlightInfo() -> FlightInfo {
        let view = FlightInfo(viewModel: flightViewModel, api: flightAPI)
        return view
    }
    
    static func buildWeatherView() -> Weather {
        let view = Weather(viewModel: weatherViewModel, api: weatherAPI)
        return view
    }
    
    
    //MARK: - Fetch Methods
    ///TODO: ASYNCSEQUENCE / ASYNCSTREAM
    
    static func fetchAll() {

        
        Task{
            await elementsAPI.fetch()
            await areasAPI.mapPlane()
//            accessAPI.registerDevice()
        }
        
        
//        do {
//            let readout = try FileCacheUtil.retrieveCachedFile(dataModel: AccessModel.self)
//        } catch {
//            accessAPI.fetch()
//        }
//
//
//        do {
//            let readout = try FileCacheUtil.retrieveCachedFile(dataModel: LightModel.self)
//            lightsViewModel.updateValues(true, readout)
//        } catch {
//            print("Light cache empty")
//            lightsAPI.fetch()
//        }
//
//        do {
//            let readout = try FileCacheUtil.retrieveCachedFile(dataModel: ShadeModel.self)
//            shadesViewModel.updateValues(true, readout)
//        } catch {
//            print("Shades cache empty")
//            shadesAPI.fetch()
//        }
//
//        do {
//            let readout = try FileCacheUtil.retrieveCachedFile(dataModel: SeatModel.self)
//            seatsViewModel.updateValues(true, readout)
//        } catch {
//            print("Seats cache empty")
//            seatsAPI.fetch()
//        }
//
//        ///Non Caching
//        cabinClimateAPI.fetch()
//
//        do {
//            let readout = try FileCacheUtil.retrieveCachedFile(dataModel: MonitorModel.self)
//            monitorsViewModel.updateValues(true, readout)
//        } catch {
//            print("Monitors cache empty")
//            monitorsAPI.fetch()
//        }
//
//        do {
//            let readout = try FileCacheUtil.retrieveCachedFile(dataModel: SpeakerModel.self)
//            speakersViewModel.updateValues(true, readout)
//        } catch {
//            print("Speakers cache empty")
//            speakersAPI.fetch()
//        }
//
//        do {
//            let readout = try FileCacheUtil.retrieveCachedFile(dataModel: SourceModel.self)
//            sourcesViewModel.updateValues(true, readout)
//        } catch {
//            print("Sources cache empty")
//            sourcesAPI.fetch()
//        }
//
//        ///Non Caching
//        flightAPI.fetch()
//        weatherAPI.fetch()
    }
    
    
    //MARK: - Navigation Builders

    static func buildRootTabNavigation() -> RootTabCoordinator {
        let coordinator = RootTabCoordinator()
        coordinator.navigationController.tabBar.tintColor = .white
        
        let tabOne = AppFactory.buildHomeMenu()
        let tabTwo = UIHostingController(rootView: MediaTab())
        let tabThree = UIHostingController(rootView: FlightTab())
        
        tabOne.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(systemName: "play"), selectedImage: UIImage(systemName: "play.fill"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane.circle"))
     
        
        coordinator.start(subviews: [tabOne.navigationController,tabTwo,tabThree])
        return coordinator
    }
    
    static func buildHomeMenu() -> HomeMenuCoordinator {
        
        let rootMenuView = UIHostingController(rootView: Home(navigation: homeMenuCoordinator))
        rootMenuView.title = "Home"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        //        navigationBarAppearance.backgroundColor = .systemIndigo
        rootMenuView.navigationItem.standardAppearance = navigationBarAppearance
        rootMenuView.navigationItem.compactAppearance = navigationBarAppearance
        rootMenuView.navigationItem.scrollEdgeAppearance = navigationBarAppearance

        let planeMenu = UIHostingController(rootView: AppFactory.buildPlaneSchematic())
        planeMenu.title = "Select your seat"
        
        let volumeMenu = UIHostingController(rootView: AppFactory.buildVolumeView())
        volumeMenu.title = "Volume"
        
        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(volumeClick))
        let icon = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(attendantClick))
        rootMenuView.navigationItem.rightBarButtonItems = [volume, icon]
        
        homeMenuCoordinator.start(subviews: [rootMenuView])
        
        return homeMenuCoordinator
    }
    
    //MARK: - Nav Utils
    
    @objc static func volumeClick() {
        homeMenuCoordinator.navigationController.present(self.volumeMenu, animated: true)
    }
    
    @objc static func attendantClick() {
        homeMenuCoordinator.navigationController.present(UIHostingController(rootView: AppFactory.buildPlaneSchematic()), animated: true)
    }
    
}
