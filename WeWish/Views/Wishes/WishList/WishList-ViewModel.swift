//
//  WishList-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 01.11.23.
//

import SwiftUI

extension WishList {
    
    enum WishType: String, CaseIterable {
        case all = "All"
        case IBuy = "I'll buy"
    }
    
    @MainActor class ViewModel: ObservableObject, WishCoreDataProtocol {
        @Published private(set) var _selectedChartType = WishType.all.rawValue
        
        var selectedChartType: Binding<String> {
            Binding {
                self._selectedChartType
            } set: { newValue in
                self._selectedChartType = newValue
            }
        }
        
        func setSelectedChartType(_ value: String) {
            _selectedChartType = value
        }
    }
}
