//
//  SettingsItemViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import Foundation

extension SettingsViewModel {
    struct SettingsItemViewModel {
        let title: String
        let iconName: String
        let type: SettingsItemType
    }
    
    enum SettingsItemType {
        case account
        case mode
        case privacy
    }
}
