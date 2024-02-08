//
//  FolderCoreDataProtocol.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 27.11.23.
//

import SwiftUI

protocol FolderCoreDataProtocol {
    func updateName(_ coreDataModel: CoreDataModel, _ folder: Folder, _ newName: String) async
    func deleteFolder(_ coreDataModel: CoreDataModel, _ folder: Folder) async
}

extension FolderCoreDataProtocol {
    @MainActor func updateName(_ coreDataModel: CoreDataModel, _ folder: Folder, _ newName: String) async {
        if !folder.isRoot {
            folder.name = newName.trimmingCharacters(in: .whitespaces)
            coreDataModel.saveContext()
            coreDataModel.refreshFolders()
        }
    }
    
    @MainActor func deleteFolder(_ coreDataModel: CoreDataModel, _ folder: Folder) async {
        // Only owner can delete
        if coreDataModel.isOwner(object: folder) && !folder.isRoot {
            coreDataModel.context.delete(folder)
            coreDataModel.saveContext()
        }
    }
}
