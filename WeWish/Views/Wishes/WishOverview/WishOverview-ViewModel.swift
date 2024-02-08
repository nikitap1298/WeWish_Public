//
//  WishOverview-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import SwiftUI

extension WishOverview {
    @MainActor class ViewModel: ObservableObject, WishCoreDataProtocol {
        @Published private(set) var currentPrice = 0.0
        @Published private(set) var isCopied = false
        @Published private(set) var pdfURL: URL?
        @Published private(set) var _showActivityVC = false
        @Published private(set) var _showEditWishSheet = false
        @Published private(set) var _showCompleteConfirmationSheet = false
        private(set) var isOwner = false
        @Published private(set) var numberOfUsers = 0
        
        @Published private(set) var animateBottomButton = false
        
        var showActivityVC: Binding<Bool> {
            Binding {
                self._showActivityVC
            } set: { newValue in
                self._showActivityVC = newValue
            }
        }
        
        var showEditWishSheet: Binding<Bool> {
            Binding {
                self._showEditWishSheet
            } set: { newValue in
                self._showEditWishSheet = newValue
            }
        }
        
        var showCompleteConfirmationSheet: Binding<Bool> {
            Binding {
                self._showCompleteConfirmationSheet
            } set: { newValue in
                self._showCompleteConfirmationSheet = newValue
            }
        }
        
        func setCurrentPrice(_ value: Double) {
            withAnimation(.bouncy) {
                currentPrice = value
            }
        }
        
        func setIsCopied(_ value: Bool) {
            isCopied = value
        }
        
        func setPDFURL(_ value: URL) {
            pdfURL = value
        }
        
        func toggleActivityVC() {
            _showActivityVC.toggle()
        }
        
        func toggleShowEditWishSheet() {
            _showEditWishSheet.toggle()
        }
        
        func toggleShowCompleteConfirmationSheet() {
            _showCompleteConfirmationSheet.toggle()
        }
        
        func setIsOwner(_ coreDataModel: CoreDataModel) {
            if let selectedWish = coreDataModel.selectedWish {
                isOwner = coreDataModel.isOwner(object: selectedWish)
            }
        }
        
        func handleIWillBuy(_ coreDataModel: CoreDataModel, _ wish: Wish, _ userId: String) {
            Task {
                await updateBuyUserId(coreDataModel, wish, userId)
            }
        }
        
        func setAnimateBottomButton(_ value: Bool) {
            animateBottomButton = value
        }
        
        func setNumberOfUsers(_ value: Int?) {
            numberOfUsers = value ?? 0
        }
    }
}
