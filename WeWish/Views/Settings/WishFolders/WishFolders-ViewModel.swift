//
//  WishFolders-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 27.11.23.
//

import SwiftUI

extension WishFoldersView {
    @MainActor class ViewModel: ObservableObject, FolderCoreDataProtocol {
        @Published private var _showNewCreateFolderSheet = false
        @Published private(set) var _showPaywallSheet = false
        @Published private(set) var swipedFolder: Folder?
        @Published private(set) var _showRenameAlert = false
        @Published private(set) var _newFolderName = ""
        @Published private(set) var _showDeleteAlert = false
        @Published private(set) var _showRootFolderInfoAlert = false
        
        var showCreateFolderSheet: Binding<Bool> {
            Binding {
                self._showNewCreateFolderSheet
            } set: { newValue in
                self._showNewCreateFolderSheet = newValue
            }
        }
        
        var showPaywallSheet: Binding<Bool> {
            Binding {
                self._showPaywallSheet
            } set: { newValue in
                self._showPaywallSheet = newValue
            }
        }
        
        var showRenameAlert: Binding<Bool> {
            Binding {
                self._showRenameAlert
            } set: { newValue in
                self._showRenameAlert = newValue
            }
        }
        
        var newFolderName: Binding<String> {
            Binding {
                self._newFolderName
            } set: { newValue in
                self._newFolderName = newValue
            }
        }
        
        var showDeleteAlert: Binding<Bool> {
            Binding {
                self._showDeleteAlert
            } set: { newValue in
                self._showDeleteAlert = newValue
            }
        }
        
        var showRootFolderInfoAlert: Binding<Bool> {
            Binding {
                self._showRootFolderInfoAlert
            } set: { newValue in
                self._showRootFolderInfoAlert = newValue
            }
        }
        
        func toggleCreateNewFolderSheet() {
            _showNewCreateFolderSheet.toggle()
        }
        
        func toggleShowPaywallSheet() {
            _showPaywallSheet.toggle()
        }
        
        func setSwipedFolderAndNewFolderName(_ folder: Folder) {
            swipedFolder = folder
            guard let swipedFolder = swipedFolder,
                  let name = swipedFolder.name else { return }
            _newFolderName = name
        }
        
        func toggleShowRenameAlert() {
            _showRenameAlert.toggle()
        }
        
        func toggleShowDeleteAlert() {
            _showDeleteAlert.toggle()
        }
        
        func toggleShowRootFolderInfoAlert() {
            _showRootFolderInfoAlert.toggle()
        }
    }
}
