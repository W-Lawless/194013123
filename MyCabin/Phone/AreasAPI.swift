//
//  AreasAPI.swift
//  MyCabin
//
//  Created by Lawless on 12/5/22.
//

import Foundation
import Combine

class AreasAPI {
    
//    let viewModel: PlaneViewModel
//    var cancelToken: Cancellable?
//
//    let endpoint = Endpoint<EndpointFormats.Get, AreaModel>(path: "/api/v1/areas")
//
//    init(viewModel: PlaneViewModel) {
//        self.viewModel = viewModel
//    }
//
//    func fetch() {
//        let publisher = Session.shared.publisher(for: endpoint, using: nil)
//
//        self.cancelToken = publisher.sink(
//            receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print(error)
//                case .finished:
//                    return
//                }
//            },
//            receiveValue: { areas in
//
//            }
//        )
//
//    }
//    
//    func mapPlane() async -> Plane {
//        var plane = Plane(areas: [PlaneArea](), id: "MyGulfstream007")
//        
//        let areaEndpoint = Endpoint<EndpointFormats.Get, AreaModel>(path: "/api/v1/areas").makeRequest(with: ())!
//        let lightsEndpoint = Endpoint<EndpointFormats.Get, LightModel>(path: "/api/v1/lights").makeRequest(with: ())!
//        let seatsEndpoint = Endpoint<EndpointFormats.Get, SeatModel>(path: "/api/v1/seats").makeRequest(with: ())!
//        let monitorsEndpoint = Endpoint<EndpointFormats.Get, MonitorModel>(path: "/api/v1/monitors").makeRequest(with: ())!
//        let speakersEndpoint = Endpoint<EndpointFormats.Get, SpeakerModel>(path: "/api/v1/speakers").makeRequest(with: ())!
//        let sourcesEndpoint = Endpoint<EndpointFormats.Get, SourceModel>(path: "/api/v1/sources").makeRequest(with: ())!
//        let shadesEndpoint = Endpoint<EndpointFormats.Get, ShadeModel>(path: "/api/v1/windows").makeRequest(with: ())!
//        let decoder = JSONDecoder()
//        //for each area, initialize a planearea struct with the mapped lights, seats, etc
//        do {
//            async let (areaData,_) = Session.shared.data(for: areaEndpoint)
//            async let (lightData,_) = Session.shared.data(for: lightsEndpoint)
//            async let (seatsData,_) = Session.shared.data(for: seatsEndpoint)
//            async let (monitorsData,_) = Session.shared.data(for: monitorsEndpoint)
//            async let (speakersData,_) = Session.shared.data(for: speakersEndpoint)
//            async let (sourcesData,_) = Session.shared.data(for: sourcesEndpoint)
//            async let (shadesData,_) = Session.shared.data(for: shadesEndpoint)
//            
//            let areas = try decoder.decode(NetworkResponse<AreaModel>.self, from: await areaData)
//            let allLights = try decoder.decode(NetworkResponse<LightModel>.self, from: await lightData)
//            let allSeats = try decoder.decode(NetworkResponse<SeatModel>.self, from: await seatsData)
//            let allMonitors = try decoder.decode(NetworkResponse<MonitorModel>.self, from: await monitorsData)
//            let allSpeakers = try decoder.decode(NetworkResponse<SpeakerModel>.self, from: await speakersData)
//            let allSources = try decoder.decode(NetworkResponse<SourceModel>.self, from: await sourcesData)
//            let allShades = try decoder.decode(NetworkResponse<ShadeModel>.self, from: await shadesData)
//            
//            areas.results.forEach { area in
////                plane.areas[area.id] = area
//                var tempLights = [LightModel]()
//                var tempSeats = [SeatModel]()
//                var tempMonitors = [MonitorModel]()
//                var tempSpeakers = [SpeakerModel]()
//                var tempSources = [SourceModel]()
//                var tempShades = [ShadeModel]()
//                
//                area.sub.forEach { subElement in
//                    switch(subElement.type) {
//                    case ElementTypes.LIGHT.rawValue:
//                        let matching = allLights.results.filter {
//                            return $0.id == subElement.id
//                        }
//                        if (!matching.isEmpty) {
//                            tempLights.append(matching[0])
//                        }
//                    case ElementTypes.SEAT.rawValue:
//                        let matching = allSeats.results.filter {
//                            return $0.id == subElement.id
//                        }
//                        if (!matching.isEmpty) {
//                            tempSeats.append(matching[0])
//                        }
//                    case ElementTypes.WINDOW.rawValue:
//                        let matching = allShades.results.filter{
//                            return $0.id == subElement.id
//                        }
//                        if (!matching.isEmpty) {
//                            tempShades.append(matching[0])
//                        }
//                    case ElementTypes.MONITOR.rawValue:
//                        let matching = allMonitors.results.filter{
//                            return $0.id == subElement.id
//                        }
//                        if (!matching.isEmpty) {
//                            tempMonitors.append(matching[0])
//                        }
//                    case ElementTypes.SPEAKER.rawValue:
//                        let matching = allSpeakers.results.filter{
//                            return $0.id == subElement.id
//                        }
//                        if (!matching.isEmpty) {
//                            tempSpeakers.append(matching[0])
//                        }
//                    case ElementTypes.SOURCE.rawValue:
//                        let matching = allSources.results.filter{
//                            return $0.id == subElement.id
//                        }
//                        if (!matching.isEmpty) {
//                            tempSources.append(matching[0])
//                        }
//                    default:
//                        Void()
//                    }
//                }
////                print(area.id, tempLights)
//                plane.areas.append(PlaneArea(id: area.id, rect: area.rect, lights: tempLights, seats: tempSeats, shades: tempShades, monitors: tempMonitors, speakers: tempSpeakers, sources: tempSources))
//            }
//            
//        } catch {
//            print(error)
//        }
//        
//        
//        plane.areas.forEach { value in
//            print("🟨",value.id)
//            print(value.rect)
//            print("    💡 Lights::")
//            value.lights?.forEach { light in
//                print("    ",light)
//            }
//            print("    💺 Seats::")
//            value.seats?.forEach { seat in
//                print("    ",seat)
//            }
//            print("    🪟 Shades::")
//            value.shades?.forEach { shade in
//                print("    ",shade)
//            }
//            print("    📺 Monitors::")
//            value.monitors?.forEach { monitor in
//                print("    ",monitor)
//            }
//            print("    🔊 Speakers::")
//            value.speakers?.forEach { speaker in
//                print("    ",speaker)
//            }
//            print("    🔌 Sources::")
//            value.sources?.forEach { source in
//                print("    ",source)
//            }
//            
//        }
////        viewModel.updateValues(true, plane)
//        return plane
//    }
}

