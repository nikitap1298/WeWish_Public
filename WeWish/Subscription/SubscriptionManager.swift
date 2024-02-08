//
//  SubscriptionManager.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 26.11.23.
//

import RevenueCat
import StoreKit
import SwiftUI

@MainActor class SubscriptionManager: ObservableObject {
    @Published private(set) var hasSubscription = false
    
    init() {
        fetchSubscriptionStatus()
    }
    
    func fetchSubscriptionStatus(_ coreDataModel: CoreDataModel? = nil) {
        Purchases.shared.getCustomerInfo { [weak self] customer, error in
            if customer?.entitlements[RevenueCat.entitlementPro]?.isActive == true {
                print("Subscription is Active")
                self?.hasSubscription = true
            } else {
                print("Subscription is not Active")
                self?.hasSubscription = false
            }
            
            if !(self?.hasSubscription ?? true) {
                guard let coreDataModel = coreDataModel,
                      let ownedRootFolder = coreDataModel.ownedRootFolder else { return }
                coreDataModel.stopOwnedFoldersSharing()
                coreDataModel.setSelectedOwnedFolder(ownedRootFolder)
                UserDefaults.standard.setValue(ownedRootFolder.name, forKey: UserDefaultsKey.selectedOwnedFolderName)
            }
        }
    }
}
