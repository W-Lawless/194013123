//
//  ElementsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation

struct ElementsAPI {
    
    let viewModel: MapViewModel
    private let endpoint = Endpoint<EndpointFormats.Get, AreaModel>(path: "/api/v1/elements").makeRequest(with: ())!
    
    func fetch() async -> PlaneMap {
        
        var allLights = [LightModel]()
        var allSeats = [SeatModel]()
        var allMonitors = [MonitorModel]()
        var allSpeakers = [SpeakerModel]()
        var allSources = [SourceModel]()
        var allShades = [ShadeModel]()
        var allAreas = [AreaModel]()
        var allTables = [TableModel]()
        var allDivans = [DivanModel]()
        
        do {
            let (planeData,_) = try await Session.shared.data(for: endpoint)
            let result = try JSONDecoder().decode(ElementsRoot.self, from: planeData)
            
            // INITIAL GROUPING OF ALL ELEMENTS
            
            for element in result.results {
                switch element {
                case .light(let light):
                    allLights.append(light)
                case .seat(let seat):
                    allSeats.append(seat)
                case .speaker(let speaker):
                    allSpeakers.append(speaker)
                case .monitor(let monitor):
                    allMonitors.append(monitor)
                case .shade(let shade):
                    allShades.append(shade)
                case .source(let source):
                    allSources.append(source)
                case .area(let area):
                    allAreas.append(area)
                case .table(let table):
                    allTables.append(table)
                case .divan(let divan):
                    allDivans.append(divan)
                case .ignore:
                    ()
                }
            } //: FOR LOOP
            
            var plane = PlaneMap(mapAreas: [PlaneArea](), apiAreas: allAreas, allLights: allLights, allSeats: allSeats, allMonitors: allMonitors, allSpeakers: allSpeakers, allSources: allSources, allShades: allShades, allTables: allTables, allDivans: allDivans)
            
            // CATEGORIZE ELEMENTS BY AREA
            
            allAreas.forEach { area in
                
                var areaLights = [LightModel]()
                var areaSeats = [SeatModel]()
                var areaMonitors = [MonitorModel]()
                var areaSpeakers = [SpeakerModel]()
                var areaSources = [SourceModel]()
                var areaShades = [ShadeModel]()
                var areaTables = [TableModel]()
                var areaDivans = [DivanModel]()
                
                area.sub.forEach { subElement in
                    switch(subElement.type) {
                    case ElementTypes.LIGHT.rawValue:
                        let matching = allLights.filter {
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaLights.append(matching[0])
                        }
                    case ElementTypes.SEAT.rawValue:
                        let matching = allSeats.filter {
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaSeats.append(matching[0])
                        }
                    case ElementTypes.WINDOW.rawValue:
                        let matching = allShades.filter{
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaShades.append(matching[0])
                        }
                    case ElementTypes.MONITOR.rawValue:
                        let matching = allMonitors.filter{
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaMonitors.append(matching[0])
                        }
                    case ElementTypes.SPEAKER.rawValue:
                        let matching = allSpeakers.filter{
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaSpeakers.append(matching[0])
                        }
                    case ElementTypes.SOURCE.rawValue:
                        let matching = allSources.filter{
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaSources.append(matching[0])
                        }
                    case ElementTypes.TABLE.rawValue:
                        let matching = allTables.filter{
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaTables.append(matching[0])
                        }
                    case ElementTypes.DIVAN.rawValue:
                        let matching = allDivans.filter{
                            return $0.id == subElement.id
                        }
                        if (!matching.isEmpty) {
                            areaDivans.append(matching[0])
                        }
                    default:
                        Void()
                    }
                } //: SUB ELEMENT LOOP
                
                plane.mapAreas.append(PlaneArea(id: area.id, rect: area.rect, lights: areaLights, seats: areaSeats, shades: areaShades, monitors: areaMonitors, speakers: areaSpeakers, sources: areaSources, tables: areaTables, divans: areaDivans))
                
            } //: AREA LOOP
            
            print(plane)
            return plane
            
        } catch {
            print(error)
            return PlaneMap(mapAreas: [PlaneArea](), apiAreas: [AreaModel](), allLights: [LightModel](), allSeats: [SeatModel](), allMonitors: [MonitorModel](), allSpeakers: [SpeakerModel](), allSources: [SourceModel](), allShades: [ShadeModel](), allTables: [TableModel](), allDivans: [DivanModel]())
        }
    } //: FETCH
}
