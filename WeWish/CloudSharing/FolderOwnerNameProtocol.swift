//
//  FolderOwnerNameProtocol.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 16.11.23.
//

import Foundation

protocol FolderOwnerNameProtocol {
    func setNames(_ coreDataModel: CoreDataModel, _ cloudShareManager: CloudShareManager, _ folder: Folder) async -> String
}

extension FolderOwnerNameProtocol {
    @MainActor func setNames(_ coreDataModel: CoreDataModel, _ cloudShareManager: CloudShareManager, _ folder: Folder) async -> String {
        let givenName = cloudShareManager.getFolderShare(coreDataModel, folder)?.owner.userIdentity.nameComponents?.givenName ?? ""
        
        let familyName = cloudShareManager.getFolderShare(coreDataModel, folder)?.owner.userIdentity.nameComponents?.familyName ?? ""
        
        return givenName.prefix(1) + "." + " " + familyName
    }
}
