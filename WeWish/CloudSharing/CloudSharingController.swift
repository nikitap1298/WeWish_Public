//
//  CloudSharingController.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 13.11.23.
//

import CloudKit
import SwiftUI

struct CloudSharingView: UIViewControllerRepresentable {
    let share: CKShare
    let container: CKContainer
    let folder: Folder
    
    func makeCoordinator() -> CloudSharingCoordinator {
        CloudSharingCoordinator(folder: folder)
    }
    
    func makeUIViewController(context: Context) -> UICloudSharingController {
        share[CKShare.SystemFieldKey.title] = folder.name
        let controller = UICloudSharingController(share: share, container: container)
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        controller.availablePermissions = [.allowPrivate, .allowPublic, .allowReadWrite]
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {
    }
}

final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
    let stack = CoreDataModel.shared
    let folder: Folder
    init(folder: Folder) {
        self.folder = folder
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        folder.name
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Failed to save share: \(error)")
    }
    
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Saved the share")
    }
    
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        if !stack.isOwner(object: folder) {
            for wish in folder.wishArray {
                CoreDataModel.shared.context.delete(wish)
            }
            CoreDataModel.shared.context.delete(folder)
        }
    }
}
