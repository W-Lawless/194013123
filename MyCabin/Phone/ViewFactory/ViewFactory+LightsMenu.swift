//
//  ViewFactory+LightsMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    //MARK: - Lights Menu
    
    @ViewBuilder
    func buildLightsMenu() -> some View {
        Lights(viewModel: state.lightsViewModel) {
            self.buildLightsBottomPanel()
        } planeView: {
            self.buildPlaneSchematic(.showLights)
        }
        
    }
    
    @ViewBuilder
    func buildLightsBottomPanel() -> some View {
        LightsBottomPanel() { light in
            self.buildAdjustablePowerButton(light: light)
        } lightPowerButton: { light in
            self.buildLightPowerButton(light: light)
        }
    }
    
    @ViewBuilder
    func buildAdjustablePowerButton(light: LightModel) -> some View {
        AdjustablePowerButton(apiClient: api.apiClient, light: light)
    }
    
    @ViewBuilder
    func buildLightPowerButton(light: LightModel) -> some View {
        LightPowerButton(apiClient: api.apiClient, light: light)
    }
    
}
