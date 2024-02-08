//
//  Persistence.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
        let container: NSPersistentCloudKitContainer

        private init() {
            container = NSPersistentCloudKitContainer(name: "Model")
            configureContainer()
        }

        private func configureContainer() {
            guard let privateStoreDescription = container.persistentStoreDescriptions.first,
                  let containerIdentifier = privateStoreDescription.cloudKitContainerOptions?.containerIdentifier else {
                fatalError("Unable to get persistentStoreDescription or containerIdentifier")
            }

            let storesURL = privateStoreDescription.url?.deletingLastPathComponent()
            privateStoreDescription.url = storesURL?.appendingPathComponent("private.sqlite")

            let sharedStoreURL = storesURL?.appendingPathComponent("shared.sqlite")
            guard let sharedStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
                fatalError("Copying the private store description returned an unexpected value.")
            }
            sharedStoreDescription.url = sharedStoreURL

            let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
            sharedStoreOptions.databaseScope = .shared
            sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions

            container.persistentStoreDescriptions.append(sharedStoreDescription)

            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Failed to load persistent stores: \(error.localizedDescription)")
                }
            }

            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.viewContext.automaticallyMergesChangesFromParent = true

            do {
                try container.viewContext.setQueryGenerationFrom(.current)
            } catch {
                fatalError("Failed to pin viewContext to the current generation: \(error.localizedDescription)")
            }
        }
}
