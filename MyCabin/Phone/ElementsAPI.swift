//
//  ElementsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation

let PARENT_IDENTIFIER = "AIRPLANE_AREA"

struct ElementsAPI {
    
    let planeViewModel: PlaneViewModel
    private let endpoint = Endpoint<EndpointFormats.Get, AreaModel>(path: .elements).makeRequest(with: ())!
    
    private var elements: [String:[Codable]] = [
         "allAreas": [AreaModel](),
         "allLights": [LightModel](),
         "allSeats": [SeatModel](),
         "allMonitors": [MonitorModel](),
         "allSpeakers": [SpeakerModel](),
         "allSources": [SourceModel](),
         "allShades": [ShadeModel](),
         "allTables": [TableModel](),
         "allDivans": [DivanModel]()
    ]
    
    init(viewModel: PlaneViewModel) {
        self.planeViewModel = viewModel
    }
    
    mutating func fetch() async {
        
        do {
            let (planeData,_) = try await Session.shared.data(for: endpoint)
            let result = try JSONDecoder().decode(ElementsRoot.self, from: planeData)
            
            // INITIAL GROUPING OF ALL ELEMENTS
            
            mapResultsToClassDictionary(result: result)
                        
            mapLightsToSeat()
            
            updateAndCacheValues()
            
            var plane = PlaneMap(
                mapAreas: [PlaneArea](),
                apiAreas: elements["allAreas"] as! [AreaModel],
                allLights: elements["allLights"] as! [LightModel],
                allSeats: elements["allSeats"] as! [SeatModel],
                allMonitors: elements["allMonitors"] as! [MonitorModel],
                allSpeakers: elements["allSpeakers"] as! [SpeakerModel],
                allSources: elements["allSources"] as! [SourceModel],
                allShades: elements["allShades"] as! [ShadeModel],
                allTables: elements["allTables"] as! [TableModel],
                allDivans: elements["allDivans"] as! [DivanModel]
            )
            
            // CATEGORIZE ELEMENTS BY AREA
            
            mapToPlaneAreas(allAreas: elements["allAreas"] as! [AreaModel], plane: &plane)
            
            filterPlaneAreas(&plane)
            
            PlaneFactory.planeElements = plane
            
            await planeViewModel.updateValues(plane)
            
            FileCacheUtil.cacheToFile(data: plane)
            
        } catch {
            print(error)
            await planeViewModel.updateValues(PlaneMap())
        }
    } //: FETCH
    
    private mutating func mapResultsToClassDictionary(result: ElementsRoot) {
        for element in result.results {
            switch element {
            case .light(let light):
                elements["allLights"]?.append(light)
            case .seat(let seat):
                elements["allSeats"]?.append(seat)
            case .speaker(let speaker):
                elements["allSpeakers"]?.append(speaker)
            case .monitor(let monitor):
                elements["allMonitors"]?.append(monitor)
            case .shade(let shade):
                elements["allShades"]?.append(shade)
            case .source(let source):
                elements["allSources"]?.append(source)
            case .area(let area):
                elements["allAreas"]?.append(area)
            case .table(let table):
                elements["allTables"]?.append(table)
            case .divan(let divan):
                elements["allDivans"]?.append(divan)
            case .ignore:
                ()
            }
        } //: FOR LOOP
        
    }
    
    private mutating func mapLightsToSeat() {
        let seats = elements["allSeats"]! as! [SeatModel]
        let lights = elements["allLights"]! as! [LightModel]
        let transformedSeats = seats.map { seat in
            var lightsINeed = [LightModel]()
            seat.assoc.forEach { item in
                guard let item = item else { return }
                
                if (item.decoratorType == "Light") {
                    
                    let target = lights.filter { light in
                        return item.id == light.id
                    }
                    
                    lightsINeed.append(target[0])
                }
            }
            var copy = seat
            copy.lights = lightsINeed
            return copy
        } //: FOR LOOP
        elements["allSeats"] = transformedSeats
    }
    
    private func updateAndCacheValues() {
        
        let allLights = elements["allLights"]! as! [LightModel]
        let allSeats = elements["allSeats"]! as! [SeatModel]
        let allMonitors = elements["allMonitors"] as! [MonitorModel]
        let allSpeakers = elements["allSpeakers"] as! [SpeakerModel]
        let allSources = elements["allSources"] as! [SourceModel]
        let allShades = elements["allShades"] as! [ShadeModel]
    
        
        StateFactory.lightsViewModel.updateValues(allLights)
        FileCacheUtil.cacheToFile(data: allLights)
        
        StateFactory.seatsViewModel.updateValues(allSeats)
        FileCacheUtil.cacheToFile(data: allSeats)

        StateFactory.monitorsViewModel.updateValues(allMonitors)
        FileCacheUtil.cacheToFile(data: allMonitors)

        StateFactory.speakersViewModel.updateValues(allSpeakers)
        FileCacheUtil.cacheToFile(data: allSpeakers)

        StateFactory.sourcesViewModel.updateValues(allSources)
        FileCacheUtil.cacheToFile(data: allSources)

        StateFactory.shadesViewModel.updateValues(allShades)
        FileCacheUtil.cacheToFile(data: allShades)
    }
    
    private func mapToPlaneAreas(allAreas: [AreaModel], plane: inout PlaneMap) {
        allAreas.forEach { area in
                        
            let allLights =  elements["allLights"] as! [LightModel]
            let allSeats =  elements["allSeats"] as! [SeatModel]
            let allMonitors =  elements["allMonitors"] as! [MonitorModel]
            let allSpeakers =  elements["allSpeakers"] as! [SpeakerModel]
            let allSources =  elements["allSources"] as! [SourceModel]
            let allShades =  elements["allShades"] as! [ShadeModel]
            let allTables =  elements["allTables"] as! [TableModel]
            let allDivans =  elements["allDivans"] as! [DivanModel]
            
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
            if(area.id == PARENT_IDENTIFIER) {
                plane.parentArea = PlaneArea(id: area.id, rect: area.rect, lights: areaLights, seats: areaSeats, shades: areaShades, monitors: areaMonitors, speakers: areaSpeakers, sources: areaSources, tables: areaTables, divans: areaDivans)
            } else {
                plane.mapAreas.append(PlaneArea(id: area.id, rect: area.rect, lights: areaLights, seats: areaSeats, shades: areaShades, monitors: areaMonitors, speakers: areaSpeakers, sources: areaSources, tables: areaTables, divans: areaDivans))
            }
            
        }
    }
    
    func filterPlaneAreas(_ plane: inout PlaneMap) {
        
        let parentID = try! NSRegularExpression(pattern: "AIRPLANE_AREA", options: .caseInsensitive)

        plane.mapAreas = plane.mapAreas.filter { area in
            
            let range = NSRange(location: 0, length: area.id.utf16.count)
            let checkParentArea = parentID.firstMatch(in: area.id, range: range)
            
            if(checkParentArea != nil) {
                return true
            } else {
                let eval = regexFilter(area.id) && area.seats?.isEmpty != true
                return eval
            }
        }

    }
    
    func regexFilter(_ target: String) -> Bool {
        
        let range = NSRange(location: 0, length: target.utf16.count)
        let lav = try! NSRegularExpression(pattern: "lav", options: .caseInsensitive)
        let crew = try! NSRegularExpression(pattern: "crew", options: .caseInsensitive)
        let galley = try! NSRegularExpression(pattern: "galley", options: .caseInsensitive)
        let vestibule = try! NSRegularExpression(pattern: "vestibule", options: .caseInsensitive)
        
        
        let lookUpOne = lav.firstMatch(in: target, range: range)
        let lookUpTwo = crew.firstMatch(in: target, range: range)
        let lookUpThree = galley.firstMatch(in: target, range: range)
        let lookUpFour = vestibule.firstMatch(in: target, range: range)
        
        if(lookUpOne == nil && lookUpTwo == nil && lookUpThree == nil && lookUpFour == nil) {
            //Target string passed all checks
            return true
        }
        
        //Target string failed
        return false
    }
    
}
