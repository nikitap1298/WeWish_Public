//
//  ShareAppView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

extension ShareAppView {
    @MainActor class ViewModel: ObservableObject {
        let applink = "https://apps.apple.com/de/app/wewish-share-your-wishes/id6470998555?l=en-GB"
        @Published private(set) var isCopied = false
        @Published private var _showActivityVC = false
        
        var showActivityVC: Binding<Bool> {
            Binding {
                self._showActivityVC
            } set: { newValue in
                self._showActivityVC = newValue
            }
        }
        
        func setIsCopied(_ value: Bool) {
            isCopied = value
        }
        
        func toggleShowActivityVC() {
            _showActivityVC.toggle()
        }
    }
}
