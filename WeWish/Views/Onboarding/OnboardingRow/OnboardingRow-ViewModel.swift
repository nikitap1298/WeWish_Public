//
//  OnboardingRow-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

extension OnboardingRow {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var showProgressView = false
        @Published private var _showLaunchingIndicator = false
        @Published private var _showNetworkViewSheet = false
        
        var showLaunchingIndicator: Binding<Bool> {
            Binding {
                self._showLaunchingIndicator
            } set: { newValue in
                self._showLaunchingIndicator = newValue
            }
        }
        
        var showNetworkViewSheet: Binding<Bool> {
            Binding {
                self._showNetworkViewSheet
            } set: { newValue in
                self._showNetworkViewSheet = newValue
            }
        }
        
        func toggleShowProgressView() {
            showProgressView.toggle()
        }
        
        func setShowLaunchingIndicator(_ value: Bool) {
            _showLaunchingIndicator = value
        }
        
        func setShowNetworkViewSheet(_ value: Bool) {
            _showNetworkViewSheet = value
        }
    }
}
