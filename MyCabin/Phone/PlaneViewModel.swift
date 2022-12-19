//
//  PlaneViewModel.swift
//  MyCabin
//
//  Created by Lawless on 12/6/22.
//

import Foundation

class PlaneViewModel: ObservableObject {
    @Published var plane: PlaneMap?
    
    @MainActor func updateValues(_ alive: Bool, _ data: PlaneMap?) {
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

    func seatIconCallback<AViewModel: ViewModelWithSubViews>(topLevelViewModel: AViewModel, seatID: String, nav: HomeMenuCoordinator) -> Void {
        UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
        
        switch self {
        case .showLights:
            topLevelViewModel.showSubView(forID: seatID)
        case .showShades:
            topLevelViewModel.showSubView(forID: seatID)
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                nav.dismiss()
            }
        } //: SWITCH
    }
    
}
    



