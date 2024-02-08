//
//  CreateFolder-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 27.11.23.
//

import SwiftUI

extension CreateFolderView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var _folderName = ""
        @Published private(set) var _showIncludeWishesSheet = false
        @Published private(set) var _showFillNameAlert = false
        @Published private(set) var isKeyboardVisible = false
        
        private let subscriptionManager = SubscriptionManager()
         
        var folderName: Binding<String> {
            Binding {
                self._folderName
            } set: { newValue in
                self._folderName = newValue
            }
        }
        
        var showIncludeWishesSheet: Binding<Bool> {
            Binding {
                self._showIncludeWishesSheet
            } set: { newValue in
                self._showIncludeWishesSheet = newValue
            }
        }
        
        var showFillNameAlert: Binding<Bool> {
            Binding {
                self._showFillNameAlert
            } set: { newValue in
                self._showFillNameAlert = newValue
            }
        }
        
        func toggleShowIncludeWishesSheet() {
            _showIncludeWishesSheet.toggle()
        }
        
        func toggleShowFillNameAlert() {
            _showFillNameAlert.toggle()
        }
        
        func setIsKeyboardVisible(_ value: Bool) {
            isKeyboardVisible = value
        }
        
        func createNewFolder(_ coreDataModel: CoreDataModel, _ currentUser: AuthDataResultModel?, _ selectedWishes: Set<Wish>? = nil) async {
            // TODO: Add an alert if folder already exists
            if _folderName != "" && !coreDataModel.ownedFolders.map({ $0.name }).contains(_folderName) && subscriptionManager.hasSubscription {
                guard let currentUserID = currentUser?.uid else { return }
                let newFolder = Folder(context: coreDataModel.context)
                newFolder.createdAt = Date.now
                newFolder.id = UUID()
                newFolder.isRoot = false
                newFolder.name = _folderName.trimmingCharacters(in: .whitespaces)
                newFolder.ownerId = currentUserID
                if let selectedWishes = selectedWishes {
                    var newSelectedWishes: [Wish] = []
                    for selectedWish in selectedWishes {
                        let copyWish = Wish(context: coreDataModel.context)
                        copyWish.id = selectedWish.id
                        copyWish.name = selectedWish.name
                        copyWish.image = selectedWish.image
                        copyWish.initialPrice = selectedWish.initialPrice
                        copyWish.url = selectedWish.url
                        copyWish.isFavorite = selectedWish.isFavorite
                        copyWish.createdAt = selectedWish.createdAt
                        coreDataModel.context.delete(selectedWish)
                        coreDataModel.saveContext()
                        newSelectedWishes.append(copyWish)
                    }
                    newFolder.wishes = NSSet(array: newSelectedWishes)
                }
                coreDataModel.saveContext()
            }
        }
        
        func hideKeyboardOnReturnPress(_ selectedTextFieldEnum: SelectedTextFieldEnum, _ newValue: String) {
            guard let newValueLastChar = newValue.last else { return }
            if newValueLastChar == "\n" {
                switch selectedTextFieldEnum {
                case .name:
                    _folderName.removeLast()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
}
