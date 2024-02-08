//
//  ContentView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 01.11.23.
//

import CloudKit
import SwiftUI

extension ContentView {
    
    enum SharedInfoAlertEnum: String, CaseIterable {
        case success = "Accepted"
        case error = "Error"
    }
    
    // UI updates happen in the @MainActor
    // If class comforts to ObservableObject add @MainActor
    // Using ViewModel will helps during testing
    // If SwiftUI view tries to change data it should go in ViewModel
    @MainActor class ViewModel: ObservableObject {
        @Published private var _showPaywallSheet = false
        @Published private var _showSharedInfoAlert = false
        @Published private(set) var sharedInfoAlertTitle = ""
        @Published private(set) var sharedInfoAlertMessage = ""
        
        var showPaywallSheet: Binding<Bool> {
            Binding {
                self._showPaywallSheet
            } set: { newValue in
                self._showPaywallSheet = newValue
            }
        }
        
        var showSharedInfoAlert: Binding<Bool> {
            Binding {
                self._showSharedInfoAlert
            } set: { newValue in
                self._showSharedInfoAlert = newValue
            }
        }
        
        func setOwnedFolder(_ coreDataModel: CoreDataModel, _ currentUser: AuthDataResultModel?) {
            if let ownedFolder = coreDataModel.folders.filter ({ $0.ownerId == currentUser?.uid && $0.isRoot == true }).first {
                coreDataModel.ownedRootFolder = ownedFolder
                
                let selectedOwnedFolderName = UserDefaults.standard.value(forKey: UserDefaultsKey.selectedOwnedFolderName) as? String
                let selectedFolderUserDefaults = coreDataModel.folders.filter { $0.ownerId == currentUser?.uid && $0.name == selectedOwnedFolderName}.first
                if let selectedFolderUserDefaults = selectedFolderUserDefaults {
                    coreDataModel.selectedOwnedFolder = selectedFolderUserDefaults
                } else {
                    coreDataModel.selectedOwnedFolder = ownedFolder
                }
            }
        }
        
        // TODO: Check this again later. Very important!!!
        // Remove ownedFolder duplicates
        func removeDuplicateFolders(_ coreDataModel: CoreDataModel) {
            let folders = coreDataModel.folders
            var seenOwnersAndRoots = Set<String>()
            var duplicates = [Folder]()
            
            for folder in folders {
                if let ownerId = folder.ownerId, folder.isRoot {
                    let uniqueIdentifier = "\(ownerId)-true"
                    if seenOwnersAndRoots.contains(uniqueIdentifier) {
                        duplicates.append(folder)
                    } else {
                        seenOwnersAndRoots.insert(uniqueIdentifier)
                    }
                }
            }
            
            print("duplicates: ", duplicates.count)
            for duplicate in duplicates {
                coreDataModel.context.delete(duplicate)
                coreDataModel.saveContext()
            }
        }
        
        // Removes folders if they are not owned and also not other users
        func removeNoOnesFolders(_ coreDataModel: CoreDataModel) {
            for folder in coreDataModel.otherUserFolders {
                if coreDataModel.getShare(folder)?.owner == nil {
                    coreDataModel.context.delete(folder)
                    coreDataModel.saveContext()
                }
            }
        }
        
        func toggleShowPaywallSheet() {
            _showPaywallSheet.toggle()
        }
        
        func toggleShowSharedInfoAlert() {
            _showSharedInfoAlert.toggle()
        }
        
        func setSharedInfoAlertContent(_ value: SharedInfoAlertEnum) {
            sharedInfoAlertTitle = value.rawValue
            if value == .success {
                sharedInfoAlertMessage = "Link successfully accepted. Open the \"Shared\" tab, the list will appear there in a couple of seconds."
            } else {
                sharedInfoAlertMessage = "Error accepting the link. Try again."
            }
        }
    }
}
