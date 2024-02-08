//
//  CloudShareManager.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 13.11.23.
//

import CloudKit
import SwiftUI

@MainActor class CloudShareManager: ObservableObject {
    @Published private(set) var share: CKShare?
    
    // For FolderRow
    func getFolderShare(_ coreDataModel: CoreDataModel, _ folder: Folder) -> CKShare? {
        return coreDataModel.getShare(folder)
    }
    
    func setShare(_ share: CKShare? = nil) {
        self.share = share
    }
    
    func setFolderShare(_ coreDataModel: CoreDataModel, _ folder: Folder) {
        self.share = coreDataModel.getShare(folder)
    }
    
    func readOnlyPermision() -> Bool {
        switch share?.currentUserParticipant?.permission {
        case .readOnly:
            return true
        case .none?:
            return true
        default:
            return false
        }
    }
    
    func numberOfUsers(_ coreDataModel: CoreDataModel, _ selectedWish: Wish) -> Int? {
        return coreDataModel.getShare(selectedWish)?.participants.count
    }
}
