//
//  OwnedWishListView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 15.11.23.
//

import CloudKit
import FirebaseAuth
import SwiftUI

extension OwnedWishListView {
    
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var _showShareSheet = false
        @Published private(set) var _showCreateWishSheet = false
        @Published private(set) var selectedSortType = SortWishesEnum.byName.rawValue
        private(set) var imageURL: URL?
        private(set) var websiteLink: String?
        @Published private(set) var showProgressView = false
        @Published private(set) var _showPaywallSheet = false
        
        var showShareSheet: Binding<Bool> {
            Binding {
                self._showShareSheet
            } set: { newValue in
                self._showShareSheet = newValue
            }
        }
        
        var showCreateWishSheet: Binding<Bool> {
            Binding {
                self._showCreateWishSheet
            } set: { newValue in
                self._showCreateWishSheet = newValue
            }
        }
        
        var showPaywallSheet: Binding<Bool> {
            Binding {
                self._showPaywallSheet
            } set: { newValue in
                self._showPaywallSheet = newValue
            }
        }
        
        func setImageURL(_ url: URL?) {
            imageURL = url
        }
        
        func setWebsiteLink(_ link: String?) {
            websiteLink = link
        }
        
        func toggleShowShareSheet() {
            _showShareSheet.toggle()
        }
        
        func toggleShowCreateWishSheet() {
            _showCreateWishSheet.toggle()
        }
        
        func setSelectedSortType(_ type: String) {
            selectedSortType = type
            UserDefaults.standard.set(type, forKey: UserDefaultsKey.selectedOwnedWishesSortType)
        }
        
        func setShowProgressView(_ value: Bool) {
            showProgressView = value
        }
        
        func toggleShowPaywallSheet() {
            _showPaywallSheet.toggle()
        }
        
        func createShare(_ folder: Folder, completion: @escaping (CKShare?) -> Void) async {
            do {
                let (_, share, _) =
                try await PersistenceController.shared.container.share([folder], to: nil)
                share[CKShare.SystemFieldKey.title] = folder.name
                completion(share)
            } catch {
                fatalError("Failed during createShare: \(error.localizedDescription)")
            }
        }
        
        func handleURL() {
            imageURL = nil
            websiteLink = nil
            
            let incomingURL = UserDefaults(suiteName: "group.WeWishGroup")?.value(forKey: "incomingURL") as? String
            let imageURLBookmark = UserDefaults(suiteName: "group.WeWishGroup")?.value(forKey: "incomingImageURLBookmark") as? Data
            
            if let incomingURL {
                websiteLink = incomingURL
                toggleShowCreateWishSheet()
                UserDefaults(suiteName: "group.WeWishGroup")?.removeObject(forKey: "incomingURL")
                Task {
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    self.websiteLink = nil
                }
            } else if let imageURLBookmark {
                var isStale = false
                let url = try? URL(resolvingBookmarkData: imageURLBookmark, bookmarkDataIsStale: &isStale)
                imageURL = url
                toggleShowCreateWishSheet()
                UserDefaults(suiteName: "group.WeWishGroup")?.removeObject(forKey: "incomingImageURLBookmark")
                Task {
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    self.imageURL = nil
                }
            }
        }
    }
}
