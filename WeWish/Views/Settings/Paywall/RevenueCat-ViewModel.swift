//
//  RevenueCat-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 01.12.23.
//

import SwiftUI

extension RevenueCatPaywallView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var isMoveScrollView = false
        
        func toggleIsMoveScrollView() {
            isMoveScrollView.toggle()
        }
    }
}
