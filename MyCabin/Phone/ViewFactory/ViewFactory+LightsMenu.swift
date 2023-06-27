//
//  ViewFactory+LightsMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

extension ViewFactory {
    
    //MARK: - Lights Menu
    
    func buildLightsMenu() -> Lights {
        let view = Lights(viewModel: state.lightsViewModel, planeViewBuilder: buildPlaneSchematic, bottomPanelBuilder: buildLightsBottomPanel)
        return view
    }
    
    func buildLightsBottomPanel() -> LightsBottomPanel {
        let view = LightsBottomPanel(adjustablePowerButtonBuilder: buildAdjustablePowerButton, lightPowerButtonBuilder: buildLightPowerButton)
        return view
    }
    
    func buildAdjustablePowerButton(light: LightModel) -> AdjustablePowerButton {
        let view = AdjustablePowerButton(apiClient: state.apiClient, light: light)
        return view
    }
    
    func buildLightPowerButton(light: LightModel) -> LightPowerButton {
        let view = LightPowerButton(apiClient: state.apiClient, light: light)
        return view
    }
    
}
