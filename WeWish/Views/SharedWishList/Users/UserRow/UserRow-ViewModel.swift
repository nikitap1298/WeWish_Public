//
//  UserRow-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 15.11.23.
//

import SwiftUI

extension UserRow {
    @MainActor class ViewModel: ObservableObject, FolderOwnerNameProtocol {
        @Published private(set) var fullName = ""
        
        func setFull(_ coreDataModel: CoreDataModel, _ cloudShareManager: CloudShareManager, _ folder: Folder) async {
            fullName = await setNames(coreDataModel, cloudShareManager, folder)
        }
    }
}
