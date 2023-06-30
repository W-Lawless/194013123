//
//  ActiveMediaDeviceButton.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

import SwiftUI

struct ActiveMediaDeviceButton: View {
    
    let activeMedia: ActiveMedia
    let deviceModel: MediaDeviceModel
    let device: MediaDevice
    let iconCallback: () -> ()
    
    var body: some View {
        Image(assetUrl(activeMedia.source, device: device))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 42, maxHeight: 42)
            .accessibilityIdentifier("active_\(deviceModel.id)")
            .modifier(PlaceIcon(rect: deviceModel.rect))
            .hapticFeedback(feedbackStyle: .light) { _ in
                iconCallback()
            }
    }
    
    //TODO: - Make public util ?
    private func assetUrl(_ source: SourceModel, device: MediaDevice) -> String {
        switch (source.type) {
        case SourceTypes.aux.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.appleTV.rawValue:
            return ActiveMediaIcons.appletv.icon(device: device)
        case SourceTypes.bluray.rawValue:
            return ActiveMediaIcons.bluray.icon(device: device)
        case SourceTypes.cabinView.rawValue:
            return ActiveMediaIcons.cabinview.icon(device: device)
        case SourceTypes.camera.rawValue:
            return ActiveMediaIcons.camera.icon(device: device)
        case SourceTypes.hdmi.rawValue:
            return ActiveMediaIcons.hdmi.icon(device: device)
        case SourceTypes.kaleid.rawValue:
            return ActiveMediaIcons.kaleid.icon(device: device)
        case SourceTypes.onDemand.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.roku.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.satTV.rawValue:
            return ActiveMediaIcons.satTV.icon(device: device)
        case SourceTypes.usbC.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.xm.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        default:
            return "ic_monitor_on"
        }
    }
}
