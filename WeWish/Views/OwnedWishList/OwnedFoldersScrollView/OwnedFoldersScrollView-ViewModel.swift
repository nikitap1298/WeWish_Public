//
//  OwnedFoldersScrollView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 25.12.23.
//

import SwiftUI

extension OwnedFoldersScrollView {
    @MainActor class ViewModel: ObservableObject {
        @Published private var _scrollPosition: Folder?
        @Published private var _showPaywallSheet = false
        
        var scrollPosition: Binding<Folder?> {
            Binding {
                self._scrollPosition
            } set: { newValue in
                self._scrollPosition = newValue
            }
        }
        
        var showPaywallSheet: Binding<Bool> {
            Binding {
                self._showPaywallSheet
            } set: { newValue in
                self._showPaywallSheet = newValue
            }
        }
        
        func setScrollPosition(_ folder: Folder?) {
            _scrollPosition = folder
        }
        
        func toggleShowPaywallSheet() {
            _showPaywallSheet.toggle()
        }
    }
}
