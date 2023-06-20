//
//  ElementsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation

let PARENT_IDENTIFIER = "AIRPLANE_AREA"

class ElementsAPI {
    
    let planeViewModel: PlaneViewModel
    private let endpoint = Endpoint<EndpointFormats.Get, AreaModel>(path: .elements).makeRequest(with: nil)!
    private let ep = Endpoint<EndpointFormats.Get, ElementsEnum>(path: .elements)
    
    private var elements: [String:[Codable]] = [
         "allAreas": [AreaModel](),
         "allLights": [LightModel](),
         "allSeats": [SeatModel](),
         "allMonitors": [MonitorModel](),
         "allSpeakers": [SpeakerModel](),
         "allSources": [SourceModel](),
         "allShades": [ShadeModel](),
         "allTables": [TableModel](),
         "allDivans": [DivanModel](),
         "allTempCtrlrs": [ClimateControllerModel]()
    ]
    
    init(viewModel: PlaneViewModel) {
        self.planeViewModel = viewModel
    }
    
    func fetch() async {
        
            
            StateFactory.apiClient.fetch(for: ep) { [weak self] res in
                let result = ElementsRoot(results: res, length: res.count)
                
//                let (planeData,_) = try await Session.shared.data(for: endpoint)
//                let result = try JSONDecoder().decode(ElementsRoot.self, from: planeData)
                // INITIAL GROUPING OF ALL ELEMENTS
                //
                self?.mapResultsToInstanceDictionary(result: result)

                self?.mapLightsToSeat()

                let sourceTypes = self?.findUniqueSourceTypes()

                self?.updateAndCacheValues()

                PlaneFactory.planeMap = PlaneMap(
                    mapAreas: [PlaneArea](),
                    apiAreas: self?.elements["allAreas"] as! [AreaModel],
                    allLights: self?.elements["allLights"] as! [LightModel],
                    allSeats: self?.elements["allSeats"] as! [SeatModel],
                    allMonitors: self?.elements["allMonitors"] as! [MonitorModel],
                    allSpeakers: self?.elements["allSpeakers"] as! [SpeakerModel],
                    allSources: self?.elements["allSources"] as! [SourceModel],
                    sourceTypes: sourceTypes ?? Set<SourceType>(),
                    allShades: self?.elements["allShades"] as! [ShadeModel],
                    allTables: self?.elements["allTables"] as! [TableModel],
                    allDivans: self?.elements["allDivans"] as! [DivanModel],
                    allTempCtrlrs: self?.elements["allTempCtrlrs"] as! [ClimateControllerModel]
                )
                

                // CATEGORIZE ELEMENTS BY AREA

                self?.mapElementsToPlaneAreas(allAreas: self?.elements["allAreas"] as! [AreaModel], plane: &PlaneFactory.planeMap)

                self?.filterPlaneAreas(&PlaneFactory.planeMap)

                Task {
                    await PlaneFactory.planeViewModel.updateValues(PlaneFactory.planeMap)
                }

                FileCacheUtil.cacheToFile(data: PlaneFactory.planeMap)
                
            }
            
            
     
    } //: FETCH

    private func mapResultsToInstanceDictionary(result: ElementsRoot) {
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
            case .tempctrlr(let tempctrlr):
                elements["allTempCtrlrs"]?.append(tempctrlr)
            case .ignore:
                ()
            }
        } //: FOR LOOP
        
    }
    
    private func mapLightsToSeat() {
        let seats = elements["allSeats"]! as! [SeatModel]
        let lights = elements["allLights"]! as! [LightModel]
        let tables = elements["allTables"]! as! [TableModel]
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
                
                if(item.decoratorType == "Table") {
                    let target = tables.filter { table in
                        return item.id == table.id
                    }
                    let tableLights = target[0].assoc

                    tableLights.forEach { tableLight in
                        let l = lights.filter { light in
                            return tableLight.id == light.id
                        }
                        lightsINeed.append(l[0])
                    }
                }
            }
            var copy = seat
            copy.lights = lightsINeed
            return copy
        } //: FOR LOOP
        
        elements["allSeats"] = transformedSeats
    }
    
    private func findUniqueSourceTypes()  -> Set<SourceType> {
        var sourceTypes = Set<SourceType>()
        
        let allSources = elements["allSources"] as! [SourceModel]
        
        allSources.forEach { source in
            let type = source.type
            switch(type) {
            case SourceTypes.aux.rawValue:
                let sourceType = SourceType(id: .aux, name: "Aux", icon: .aux)
                sourceTypes.insert(sourceType)
            case SourceTypes.appleTV.rawValue:
                let sourceType = SourceType(id: .appleTV, name: "Apple TV", icon: .appleTV)
                sourceTypes.insert(sourceType)
            case SourceTypes.bluray.rawValue:
                let sourceType = SourceType(id: .bluray, name: "Blu-Ray", icon: .bluray)
                sourceTypes.insert(sourceType)
            case SourceTypes.cabinView.rawValue:
                let sourceType = SourceType(id: .cabinView, name: "Cabin View", icon: .cabinView)
                sourceTypes.insert(sourceType)
            case SourceTypes.camera.rawValue:
                let sourceType = SourceType(id: .camera, name: "Cameras", icon: .camera)
                sourceTypes.insert(sourceType)
            case SourceTypes.hdmi.rawValue:
                let sourceType = SourceType(id: .hdmi, name: "HDMI", icon: .hdmi)
                sourceTypes.insert(sourceType)
            case SourceTypes.kaleid.rawValue:
                let sourceType = SourceType(id: .kaleid, name: "Kaleidescape", icon: .kaleid)
                sourceTypes.insert(sourceType)
            case SourceTypes.onDemand.rawValue:
                let sourceType = SourceType(id: .onDemand, name: "On Demand", icon: .onDemand)
                sourceTypes.insert(sourceType)
            case SourceTypes.roku.rawValue:
                let sourceType = SourceType(id: .roku, name: "ROKU", icon: .roku)
                sourceTypes.insert(sourceType)
            case SourceTypes.satTV.rawValue:
                let sourceType = SourceType(id: .satTV, name: "Sat TV", icon: .satTV)
                sourceTypes.insert(sourceType)
            case SourceTypes.usbC.rawValue:
                let sourceType = SourceType(id: .usbC, name: "USB-C", icon: .usbC)
                sourceTypes.insert(sourceType)
            case SourceTypes.xm.rawValue:
                let sourceType = SourceType(id: .xm, name: "XM", icon: .xm)
                sourceTypes.insert(sourceType)
            default:
                break
            }
        }
        
        StateFactory.sourcesViewModel.updateSourceTypes(sourceTypes)
        FileCacheUtil.cacheToFile(data: sourceTypes)
        
        return sourceTypes
    }
    
    private func updateAndCacheValues() {
        
        let allLights = elements["allLights"]! as! [LightModel]
        let allSeats = elements["allSeats"]! as! [SeatModel]
        let allMonitors = elements["allMonitors"] as! [MonitorModel]
        let allSpeakers = elements["allSpeakers"] as! [SpeakerModel]
        let allSources = elements["allSources"] as! [SourceModel]
        let allShades = elements["allShades"] as! [ShadeModel]
        let tempCtrlrs = elements["allTempCtrlrs"] as! [ClimateControllerModel]
        
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
        
        StateFactory.climateViewModel.updateValues(tempCtrlrs)
        FileCacheUtil.cacheToFile(data: tempCtrlrs)
    }
    
    private func mapElementsToPlaneAreas(allAreas: [AreaModel], plane: inout PlaneMap) {
        allAreas.forEach { area in
                        
            let allLights =  elements["allLights"] as! [LightModel]
            let allSeats =  elements["allSeats"] as! [SeatModel]
            let allMonitors =  elements["allMonitors"] as! [MonitorModel]
            let allSpeakers =  elements["allSpeakers"] as! [SpeakerModel]
            let allSources =  elements["allSources"] as! [SourceModel]
            let allShades =  elements["allShades"] as! [ShadeModel]
            let allTables =  elements["allTables"] as! [TableModel]
            let allDivans =  elements["allDivans"] as! [DivanModel]
            let allTempCtrlrs = elements["allTempCtrlrs"] as! [ClimateControllerModel]
            
            var areaLights = [LightModel]()
            var areaSeats = [SeatModel]()
            var areaMonitors = [MonitorModel]()
            var areaSpeakers = [SpeakerModel]()
            var areaSources = [SourceModel]()
            var areaShades = [ShadeModel]()
            var areaTables = [TableModel]()
            var areaDivans = [DivanModel]()
            var areaTempCtrlrs = [ClimateControllerModel]()
            
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
                case ElementTypes.TEMPCTRL.rawValue:
                    let matching = allTempCtrlrs.filter {
                        return $0.id == subElement.id
                    }
                    if(!matching.isEmpty) {
                        areaTempCtrlrs.append(matching[0])
                    }
                default:
                    Void()
                }
            } //: SUB ELEMENT LOOP
            if(area.id == PARENT_IDENTIFIER) {
                plane.parentArea = PlaneArea(id: area.id, rect: area.rect, lights: areaLights, seats: areaSeats, shades: areaShades, monitors: areaMonitors, speakers: areaSpeakers, sources: areaSources, tables: areaTables, divans: areaDivans, zoneTemp: areaTempCtrlrs)
            } else {
                plane.mapAreas.append(PlaneArea(id: area.id, rect: area.rect, lights: areaLights, seats: areaSeats, shades: areaShades, monitors: areaMonitors, speakers: areaSpeakers, sources: areaSources, tables: areaTables, divans: areaDivans, zoneTemp: areaTempCtrlrs))
            }
            
        }
    }
    
    private func filterPlaneAreas(_ plane: inout PlaneMap) {
        
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
    
    private func regexFilter(_ target: String) -> Bool {
        
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
