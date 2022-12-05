//
//  AreasAPI.swift
//  MyCabin
//
//  Created by Lawless on 12/5/22.
//

import Foundation
import Combine

class AreasAPI {
    
//    let viewModel: LightsViewModel
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, AreaModel>(path: "/api/v1/areas")
    
//    init(viewModel: LightsViewModel) {
//        self.viewModel = viewModel
//    }
    
    func fetch() {
        print("pt2")
        let publisher = Session.shared.publisher(for: endpoint, using: nil)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("nothing?")
                    return
                }
            },
            receiveValue: { areas in
                
                areas.forEach { element in
                    var lights = []
                    var seats = []
                    var monitors = []
                    var speakers = []
                    var subAreas = []
                    var sources = []
                    
                    print("🟨 ",element.name, terminator: "\n")
                    print("  🟩 Sub Elements::")
                    
                    element.sub.forEach { subElement in
                        
                        switch(subElement.type) {
                        case ElementTypes.LIGHT.rawValue:
                            lights.append(subElement)
                        case ElementTypes.SEAT.rawValue:
                            seats.append(subElement)
                        case ElementTypes.MONITOR.rawValue:
                            monitors.append(subElement)
                        case ElementTypes.SPEAKER.rawValue:
                            speakers.append(subElement)
                        case ElementTypes.SOURCE.rawValue:
                            sources.append(subElement)
                        case ElementTypes.AREA.rawValue:
                            subAreas.append(subElement)
                        default:
                            Void()
                        }
//                        print("    > ",subElement.type)
//                        print("        > ",subElement.id)
                    }
                    
                    print("    💡 Lights::")
                    lights.forEach { light in
                        print("    ",light)
                    }
                    print("    💺 Seats::")
                    seats.forEach { seat in
                        print("    ",seat)
                    }
                    print("    📺 Monitors::")
                    monitors.forEach { monitor in
                        print("    ",monitor)
                    }
                    print("    🔊 Speakers::")
                    speakers.forEach { speaker in
                        print("    ",speaker)
                    }
                    print("    🔌 Sources::")
                    sources.forEach { source in
                        print("    ",source)
                    }
                    print("  🟦 Zone Elements::")
                    
                    element.assoc.forEach { item in
                        print("    ",item.type)
                        print("       ",item.id)
                    }
                }
//                self.viewModel.updateValues(true, lights)
//                FileCacheUtil.cacheToFile(data: lights)
            }
        )
    }
    

    
}

