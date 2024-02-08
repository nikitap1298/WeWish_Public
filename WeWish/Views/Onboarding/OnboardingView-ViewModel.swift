//
//  OnboardingView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 14.11.23.
//

import SwiftUI

extension OnboardingView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var isGetStarted = true
        
        let rowData = [
            (id: 0,
             imageName: "OnboardingRowImage1",
             title: "Your best Wishlist app",
             description: "Create, manage and share your wishes"),
            (id: 1,
             imageName: "OnboardingRowImage2",
             title: "Import wish",
             description: "Open links (any website) and images with WeWish"),
            (id: 2,
             imageName: "OnboardingRowImage3",
             title: "Shared wishes",
             description: "See and manage what your family and friends wish")
        ]
        
        func setIsGetStarted(_ value: Bool) {
            isGetStarted = value
        }
    }
}
