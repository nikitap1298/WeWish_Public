//
//  SettingsView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import SwiftUI

extension SettingsView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var _showPaywallSheet = false
        @Published private var _showRevenueCatDebug = false
        @Published private(set) var isEditMode = false
        
        var showPaywallSheet: Binding<Bool> {
            Binding {
                self._showPaywallSheet
            } set: { newValue in
                self._showPaywallSheet = newValue
            }
        }
        
        var showRevenueCatDebug: Binding<Bool> {
            Binding {
                self._showRevenueCatDebug
            } set: { newValue in
                self._showRevenueCatDebug = newValue
            }
        }
        
        func toggleShowPaywallSheet() {
            _showPaywallSheet.toggle()
        }
        
        func toggleShowRevenueCatDebug() {
            _showRevenueCatDebug.toggle()
        }
        
        func toggleIsEditMode() {
            isEditMode.toggle()
        }
    }
}
