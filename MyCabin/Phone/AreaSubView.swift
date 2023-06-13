//
//  AreaSubView.swift
//  MyCabin
//
//  Created by Lawless on 5/4/23.
//

import SwiftUI

struct AreaSubView: View {
    
    @EnvironmentObject var coordinatesModel: PlaneViewCoordinates
    @Binding var selectedZone: PlaneArea?
    
    let area: PlaneArea
    
    let options: PlaneSchematicDisplayMode

    @State var subviewHeightUnit: CGFloat = 0
    @State var subviewWidthUnit: CGFloat = 0

//    @AppStorage("CurrentSeat") var selectedSeat: String = ""
//    let selectedSeat: String = UserDefaults.standard.string(forKey: "CurrentSeat") ?? ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            AreaBlueprint(area: area, options: options, subviewHeightUnit: $subviewHeightUnit, subviewWidthUnit: $subviewWidthUnit)
            
            if(options == .showShades) {
                ShadeBlueprint(area: area, subviewHeightUnit: $subviewHeightUnit, subviewWidthUnit: $subviewWidthUnit)
            }
            
            if(options == .showMonitors) {
                MonitorsBlueprint(area: area, subviewHeightUnit: $subviewHeightUnit, subviewWidthUnit: $subviewWidthUnit)
            }
            
            if(options == .showSpeakers) {
                SpeakersBlueprint(area: area, subviewHeightUnit: $subviewHeightUnit, subviewWidthUnit: $subviewWidthUnit)
            }
            
            if(options == .showNowPlaying) {
                NowPlayingBlueprint(area: area, subviewHeightUnit: $subviewHeightUnit, subviewWidthUnit: $subviewWidthUnit)
            }
            
            if(options == .tempZones) {
                ClimateBlueprint(area: area, subviewHeightUnit: $subviewHeightUnit, subviewWidthUnit: $subviewWidthUnit)
            }

        }
        .frame(width: (subviewWidthUnit * area.rect.w), height: (subviewHeightUnit * area.rect.h))
        .onAppear {
            calculateAreaCoorindates()
        }
        .if(options == .tempZones || options == .lightZones) { subview in
                subview
                    .opacity(selectedZone?.id == area.id ? 1 : 0.3)
                    .background(selectedZone?.id == area.id ? Color.yellow.opacity(0.3) : nil)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
        }

    }
    
    private func calculateAreaCoorindates() {
        let subviewHeight = coordinatesModel.containerHeightUnit * area.rect.h
        subviewHeightUnit = subviewHeight / area.rect.h
        
        let subviewWidth = coordinatesModel.containerWidthUnit * area.rect.w
        subviewWidthUnit = subviewWidth / area.rect.w
    }
    
}

struct AreaBlueprint: View {
    let area: PlaneArea
    let options: PlaneSchematicDisplayMode
    
    @AppStorage("CurrentSeat") var selectedSeat: String = ""
    
    @Binding var subviewHeightUnit: CGFloat
    @Binding var subviewWidthUnit: CGFloat
    
    var body: some View {
        
        ForEach(area.seats ?? [SeatModel]()) { seat in
            if(seat.id == selectedSeat) {
                SeatButton(id: seat.id, options: options, selected: true)
                    .modifier(PlaceIcon(rect: seat.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            } else {
                SeatButton(id: seat.id, options: options, selected: false)
                    .modifier(PlaceIcon(rect: seat.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            }
        } //: FOR EACH
        
        ForEach(area.tables ?? [TableModel]()) { table in
            MiniTable(tableType: table.type)
                .modifier(PlaceIcon(rect: table.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
        } //: FOR EACH
        
        ForEach(area.divans ?? [DivanModel]()) { divan in
            DivanSeat(options: options)
                .modifier(PlaceIcon(rect: divan.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
        } //: FOR EACH
        
    }
}

struct ShadeBlueprint: View {
    
    let area: PlaneArea
    
    @Binding var subviewHeightUnit: CGFloat
    @Binding var subviewWidthUnit: CGFloat
    
    var body: some View {
        ForEach(area.shades ?? [ShadeModel]()) { shade in
            ShadeButton(shade: shade)
                .modifier(PlaceIcon(rect: shade.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
        } //: FOR EACH
    }
}

struct MonitorsBlueprint: View {
    
    let area: PlaneArea
    
//    @AppStorage("SelectedMonitor") var selectedMonitor: String = ""
    @ObservedObject var mediaViewModel = StateFactory.mediaViewModel
    
    @Binding var subviewHeightUnit: CGFloat
    @Binding var subviewWidthUnit: CGFloat
    
    var body: some View {
        ForEach(area.monitors ?? [MonitorModel]()) { monitor in
            if(monitor.id == mediaViewModel.selectedMonitor) {
                MonitorButton(monitor: monitor, selected: true)
                    .modifier(PlaceIcon(rect: monitor.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            } else {
                MonitorButton(monitor: monitor, selected: false)
                    .modifier(PlaceIcon(rect: monitor.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            }
        }
    }
}

struct SpeakersBlueprint: View {
    
    let area: PlaneArea
    
    @ObservedObject var mediaViewModel = StateFactory.mediaViewModel
    
    @Binding var subviewHeightUnit: CGFloat
    @Binding var subviewWidthUnit: CGFloat
    
    var body: some View {
        ForEach(area.speakers ?? [SpeakerModel]()) { speaker in
            if(speaker.id == mediaViewModel.selectedSpeaker) {
                SpeakerButton(speaker: speaker, selected: true)
                    .modifier(PlaceIcon(rect: speaker.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            } else {
                SpeakerButton(speaker: speaker, selected: false) 
                    .modifier(PlaceIcon(rect: speaker.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
            }
        }
    }
}

struct NowPlayingBlueprint: View {

    let area: PlaneArea

    @ObservedObject var mediaViewModel = StateFactory.mediaViewModel

    @Binding var subviewHeightUnit: CGFloat
    @Binding var subviewWidthUnit: CGFloat

    var body: some View {
        ForEach(Array(mediaViewModel.activeMedia.values), id: \.self) { activeMedia in
            
            ActiveMediaButton(area: area, activeMedia: activeMedia, subviewHeightUnit: $subviewHeightUnit, subviewWidthUnit: $subviewWidthUnit)
            
        }
    }
}

struct ClimateBlueprint: View {

    let area: PlaneArea

    @Binding var subviewHeightUnit: CGFloat
    @Binding var subviewWidthUnit: CGFloat

    var body: some View {
        ZStack {
            ForEach(Array(area.zoneTemp ?? [ClimateControllerModel]()), id: \.self) { tempZone in
                
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.red, lineWidth: 1)
                    .frame(width: tempZone.rect.w * subviewWidthUnit, height: tempZone.rect.h * subviewHeightUnit)
//                    .modifier(PlaceIcon(rect: tempZone.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
                
            } //: FOREACH
            
        } //: ZSTQ
    }
}

//
//struct AreaSubView_Previews: PreviewProvider {
//    static var previews: some View {
//        AreaSubView()
//    }
//}
