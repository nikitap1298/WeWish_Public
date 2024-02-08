//
//  FolderOverview-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 16.11.23.
//

import SwiftUI

extension FolderOverview {
    @MainActor class ViewModel: ObservableObject, FolderOwnerNameProtocol {
        @Published private(set) var fullName = ""
        @Published private(set) var _showShareSheet = false
        @Published private(set) var selectedSortType = SortWishesEnum.byName.rawValue
        
        var showShareSheet: Binding<Bool> {
            Binding {
                self._showShareSheet
            } set: { newValue in
                self._showShareSheet = newValue
            }
        }
        
        func toggleShowShareSheet() {
            _showShareSheet.toggle()
        }
        
        func setFull(_ coreDataModel: CoreDataModel, _ cloudShareManager: CloudShareManager, _ folder: Folder) async {
            fullName = await setNames(coreDataModel, cloudShareManager, folder)
        }
        
        func setSelectedSortType(_ type: String) {
            selectedSortType = type
            UserDefaults.standard.set(type, forKey: UserDefaultsKey.selectedSharedWishesSortType)
        }
        
    }
}
