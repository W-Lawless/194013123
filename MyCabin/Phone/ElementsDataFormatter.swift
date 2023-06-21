//
//  ElementsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation

let PARENT_IDENTIFIER = "AIRPLANE_AREA"

class ElementDataFormatter {
    
    typealias ElementsDictionary = [String:[Codable]]
    
    func mapResultsToDictionary(result: ElementsRoot) -> ElementsDictionary {
        var dictionary = buildEmptyDictionary()
        for element in result.results {
            switch element {
            case .light(let light):
                dictionary["allLights"]?.append(light)
            case .seat(let seat):
                dictionary["allSeats"]?.append(seat)
            case .speaker(let speaker):
                dictionary["allSpeakers"]?.append(speaker)
            case .monitor(let monitor):
                dictionary["allMonitors"]?.append(monitor)
            case .shade(let shade):
                dictionary["allShades"]?.append(shade)
            case .source(let source):
                dictionary["allSources"]?.append(source)
            case .area(let area):
                dictionary["allAreas"]?.append(area)
            case .table(let table):
                dictionary["allTables"]?.append(table)
            case .divan(let divan):
                dictionary["allDivans"]?.append(divan)
            case .tempctrlr(let tempctrlr):
                dictionary["allTempCtrlrs"]?.append(tempctrlr)
            case .ignore:
                ()
            }
        } //: FOR LOOP
        return dictionary
    }
    
    func mapLightsToSeat(elements: inout ElementsDictionary) {
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
    
    func findUniqueSourceTypes(elements: inout ElementsDictionary)  -> Set<SourceType> {
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
    

    
    func mapElementsToPlaneAreas(allAreas: [AreaModel], plane: inout PlaneMap, elements: inout ElementsDictionary) {
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
    
    func filterPlaneAreas(_ plane: inout PlaneMap) {

        plane.mapAreas = plane.mapAreas.filter { area in
                let eval = regexFilter(area.id) && area.seats?.isEmpty != true
                return eval
                // TRUE = INCLUDE
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
            //Target string passed all checks, include it in filter results
            return true
        }
        
        //Target string failed a regex, exclude it from filter results
        return false
    }
    
    
    func buildEmptyDictionary() -> ElementsDictionary {
        return [
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
    }
    
    func buildPlaneMap(dictionary: ElementsDictionary, sourceSet: Set<SourceType>) -> PlaneMap {
        return PlaneMap (
            mapAreas: [PlaneArea](),
            apiAreas: dictionary["allAreas"] as! [AreaModel],
            allLights: dictionary["allLights"] as! [LightModel],
            allSeats: dictionary["allSeats"] as! [SeatModel],
            allMonitors: dictionary["allMonitors"] as! [MonitorModel],
            allSpeakers: dictionary["allSpeakers"] as! [SpeakerModel],
            allSources: dictionary["allSources"] as! [SourceModel],
            sourceTypes: sourceSet,
            allShades: dictionary["allShades"] as! [ShadeModel],
            allTables: dictionary["allTables"] as! [TableModel],
            allDivans: dictionary["allDivans"] as! [DivanModel],
            allTempCtrlrs: dictionary["allTempCtrlrs"] as! [ClimateControllerModel]
        )
    }
}
