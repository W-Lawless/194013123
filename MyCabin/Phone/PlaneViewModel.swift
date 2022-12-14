//
//  PlaneViewModel.swift
//  MyCabin
//
//  Created by Lawless on 12/6/22.
//

import Foundation

class PlaneViewModel: ObservableObject {
    @Published var plane: PlaneMap?
    @Published var selectedSeat: String = ""
    @Published var showBottomPanel: Bool = false
    @Published var subViews: LightsBottomPanel = AppFactory.buildLightsPanel()
    
    func updateValues(_ alive: Bool, _ data: PlaneMap?) {
        if let data = data {
            self.plane = data
        }
    }
}


class PlaneViewCoordinates: ObservableObject {
    @Published var containerViewHeight: CGFloat = 0
    @Published var containerViewWidth: CGFloat = 0
    @Published var containerWidthUnit: CGFloat = 0
    @Published var containerHeightUnit: CGFloat = 0
}

        
enum PlaneSchematicDisplayMode: String {

    case onlySeats
    case showLights
    case showShades
    case lightZones
    case tempZones
    case showMedia

    func seatIconCallback(topLevelViewModel: LightsViewModel, seatID: String, vm: PlaneViewModel, nav: HomeMenuCoordinator) -> Void {

        UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
//        vm.selectedSeat = seatID

        switch self {
        case .showLights:
            vm.showBottomPanel = true
            topLevelViewModel.bottomPanel = AppFactory.lightSubViews[seatID]!
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                nav.dismiss()
            }
        }
    }
}
    



