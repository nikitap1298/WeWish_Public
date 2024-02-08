//
//  CoreDataModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import CloudKit
import CoreData
import SwiftUI

@MainActor
public class CoreDataModel: ObservableObject {
    static let shared = CoreDataModel()
    
    @Published var ownedRootFolder: Folder?
    @Published var selectedOwnedFolder: Folder?

    @Published var selectedOtherUserFolder: Folder?
    @Published var selectedWish: Wish?
    
    // MARK: - CoreData
    let context = PersistenceController.shared.container.viewContext
    
    private var folderList: FetchedResultList<Folder>
    private var wishList: FetchedResultList<Wish>
    
    private var _privatePersistentStore: NSPersistentStore?
    private var _sharedPersistentStore: NSPersistentStore?
    
    var ckContainer: CKContainer {
        let storeDescription = PersistenceController.shared.container.persistentStoreDescriptions.first
        guard let identifier = storeDescription?.cloudKitContainerOptions?.containerIdentifier else {
            fatalError("Unable to get container identifier")
        }
        return CKContainer(identifier: identifier)
    }
    
    var privatePersistentStore: NSPersistentStore {
        guard let privateStore = _privatePersistentStore else {
            fatalError("Private store is not set")
        }
        return privateStore
    }
    
    var sharedPersistentStore: NSPersistentStore {
        guard let sharedStore = _sharedPersistentStore else {
            fatalError("Shared store is not set")
        }
        return sharedStore
    }
    
    init() {
        _privatePersistentStore = PersistenceController.shared.container.persistentStoreCoordinator.persistentStores.first
        _sharedPersistentStore = PersistenceController.shared.container.persistentStoreCoordinator.persistentStores.last
        
        folderList = FetchedResultList(context: context,
                                       filter: nil,
                                       sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)])
        
        
        wishList = FetchedResultList(context: context,
                                     filter: nil,
                                     sortDescriptors: [NSSortDescriptor(keyPath: \Wish.name, ascending: true)])
        
        do {
            let currentUserID = try AuthManager.shared.getAuthenticatedUser().uid
            if let ownedRootFolder = folderList.items.filter ({ $0.ownerId == currentUserID && $0.isRoot == true }).first {
                self.ownedRootFolder = ownedRootFolder
                
                let selectedOwnedFolderName = UserDefaults.standard.value(forKey: UserDefaultsKey.selectedOwnedFolderName) as? String
                let selectedFolderUserDefaults = folderList.items.filter { $0.ownerId == currentUserID && $0.name == selectedOwnedFolderName}.first
                if let selectedFolderUserDefaults = selectedFolderUserDefaults {
                    self.selectedOwnedFolder = selectedFolderUserDefaults
                } else {
                    self.selectedOwnedFolder = ownedRootFolder
                }
            }
        } catch {
            print("Error during folders configuration in CoreDataModel init: \(error.localizedDescription)")
        }
        
        folderList.willChange = { [weak self] in
            self?.objectWillChange.send()
        }
        
        wishList.willChange = { [weak self] in
            self?.objectWillChange.send()
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError("Error during savingContext: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Folders
    var folders: [Folder] {
        return folderList.items
    }
    
    var ownedFolders: [Folder] {
        do {
            let currentUserID = try AuthManager.shared.getAuthenticatedUser().uid
            return folderList.items.filter { $0.ownerId == currentUserID }
        } catch {
            fatalError("Error during ownedFolders configuration in CoreDataModel: \(error.localizedDescription)")
        }
    }
    
    var otherUserFolders: [Folder] {
        do {
            let currentUserID = try AuthManager.shared.getAuthenticatedUser().uid
            print("otherUserFolders: ", folderList.items.filter { $0.ownerId != currentUserID }.count)
            var newOtherUserFolders: [Folder] = []
            for folder in folderList.items.filter({ $0.ownerId != currentUserID }) {
                if getShare(folder)?.owner != nil {
                    newOtherUserFolders.append(folder)
                }
            }
            return newOtherUserFolders
        } catch {
            fatalError("Error during otherUserFolders configuration in CoreDataModel: \(error.localizedDescription)")
        }
    }
    
    func setSelectedOwnedFolder(_ folder: Folder) {
        selectedOwnedFolder = folder
    }
    
    func refreshFolders() {
        // Add logic
        print("Refresh folders")
    }
    
    // MARK: - Wishes
    var wishes: [Wish] {
        return wishList.items
    }
    
    func refreshWishes() {
//        if let selectedFolder = selectedFolder {
//            wishList.predicate = NSPredicate(format: "folder == %@", selectedFolder)
//            print("Refresh wishes")
//        }
//        wishList.predicate = NSPredicate(format: "folder == %@", selectedFolder)
    }
    
    func hasSelectedWish() -> Binding<Bool> {
        Binding {
            self.selectedWish != nil
        } set: { selected in
            if !selected {
                self.selectedWish = nil
            }
        }
        
    }
}

// MARK: Share a record using CloudKit
extension CoreDataModel {
    func isShared(object: NSManagedObject) -> Bool {
        isShared(objectID: object.objectID)
    }
    
    func canEdit(object: NSManagedObject) -> Bool {
        return PersistenceController.shared.container.canUpdateRecord(forManagedObjectWith: object.objectID)
    }
    
    func canDelete(object: NSManagedObject) -> Bool {
        return PersistenceController.shared.container.canDeleteRecord(forManagedObjectWith: object.objectID)
    }
    
    func isOwner(object: NSManagedObject) -> Bool {
        guard isShared(object: object) else { return true }
        guard let share = try? PersistenceController.shared.container.fetchShares(matching: [object.objectID])[object.objectID] else {
            print("Get ckshare error")
            return true
        }
        if let currentUser = share.currentUserParticipant, currentUser == share.owner {
            return true
        }
        return false
    }
    
    func getShare(_ folder: Folder) -> CKShare? {
        guard isShared(object: folder) else { return nil }
        guard let shareDictionary = try? PersistenceController.shared.container.fetchShares(matching: [folder.objectID]),
              let share = shareDictionary[folder.objectID] else {
            print("Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = folder.name
        return share
    }
    
    func getShare(_ wish: Wish) -> CKShare? {
        guard isShared(object: wish) else { return nil }
        guard let shareDictionary = try? PersistenceController.shared.container.fetchShares(matching: [wish.objectID]),
              let share = shareDictionary[wish.objectID] else {
            print("Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = wish.name
        return share
    }
    
    private func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == sharedPersistentStore {
                isShared = true
            } else {
                let container = PersistenceController.shared.container
                do {
                    let shares = try container.fetchShares(matching: [objectID])
                    if shares.first != nil {
                        isShared = true
                    }
                } catch {
                    print("Error during fetchingShare for \(objectID): \(error.localizedDescription)")
                }
            }
        }
        return isShared
    }
    
    func getCurrentUser() -> CKShare.Participant? {
        guard let object = self.selectedOwnedFolder else { return nil }
        guard isShared(object: object) else { return nil }
        guard let share = try? PersistenceController.shared.container.fetchShares(matching: [object.objectID])[object.objectID] else { return nil }
        if let currentUser = share.currentUserParticipant {
            return currentUser
        }
        return nil
    }
    
    func stopOwnedFoldersSharing() {
//        if let ownedFolder = ownedRootFolder,
//           let share = getShare(ownedFolder) {
//            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [share.recordID])
//            operation.savePolicy = .changedKeys
//            operation.qualityOfService = .userInitiated
//            
//            ckContainer.privateCloudDatabase.add(operation)
//        }
        for folder in ownedFolders {
            if let share = getShare(folder) {
                let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [share.recordID])
                operation.savePolicy = .changedKeys
                operation.qualityOfService = .userInitiated
                
                ckContainer.privateCloudDatabase.add(operation)
            }
        }
    }
}
