//
//  AppearanceView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 04.12.23.
//

import SwiftUI

extension AppearanceView {
    @MainActor class ViewModel: ObservableObject {
        @AppStorage(AppStorageKeys.currentAppearanceType) private(set) var currentAppearanceTypeAppStorage = AppearanceTypeEnum.system
        @Published private(set) var currentAppearanceType = AppearanceTypeEnum.system
        
        func setCurrentAppearanceType(_ type: AppearanceTypeEnum) {
            Feedback().impactOccured()
            currentAppearanceType = type
            
            currentAppearanceTypeAppStorage = type
        }
        
        func setCurrentAppearanceTypeFromUserDefaults() {
            currentAppearanceType = currentAppearanceTypeAppStorage
        }
    }
}
