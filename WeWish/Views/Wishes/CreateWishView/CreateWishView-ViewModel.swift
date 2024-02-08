//
//  CreateWishView-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 01.11.23.
//

import FirebaseAuth
import LinkPresentation
import PhotosUI
import Photos
import SwiftUI
import SwiftSoup

extension CreateWishView {
    
    // UI updates happen in the @MainActor
    // If class comforts to ObservableObject add @MainActor
    // Using ViewModel will helps during testing
    // If SwiftUI view tries to change data it should go in ViewModel
    @MainActor class ViewModel: ObservableObject, ThumbnailProtocol {
        
        // MARK: - Properties
        @Published private(set) var _wishName = ""
        @Published private(set) var _wishItem: PhotosPickerItem?
        @Published private(set) var wishUIImage: UIImage?
        private var _wishPrice = 0
        @Published private(set) var _wishLink: String?
        @Published private(set) var thumbnailImage: UIImage?
        @Published private(set) var startSearchingThumbnail = false
        @Published private(set) var _showFillNameAlert = false
        @Published private(set) var isKeyboardVisible = false
        private(set) var updateCurrencyTextField = false
        private var wishPriceFromWeb = 0
        @Published private(set) var selectedFolder: Folder?
        
        var wishName: Binding<String> {
            Binding {
                self._wishName
            } set: { newValue in
                self._wishName = newValue
            }
        }
        
        var wishItem: Binding<PhotosPickerItem?> {
            Binding {
                self._wishItem
            } set: { newValue in
                self._wishItem = newValue
            }
        }
        
        var wishPrice: Binding<Int> {
            Binding {
                self._wishPrice
            } set: { newValue in
                self._wishPrice = newValue
            }
        }
        
        var wishLink: Binding<String> {
            Binding {
                self._wishLink ?? ""
            } set: { newValue in
                self._wishLink = newValue
            }
        }
        
        var showFillNameAlert: Binding<Bool> {
            Binding {
                self._showFillNameAlert
            } set: { newValue in
                self._showFillNameAlert = newValue
            }
        }
        
        // MARK: - Public Functions
        func setThumbnailImage(_ uiImage: UIImage?) {
            thumbnailImage = uiImage
        }
        
        func setWishUIImage(_ uiImage: UIImage?) {
            wishUIImage = uiImage
        }
        
        func setShowFillNameAlert() {
            _showFillNameAlert.toggle()
        }
        
        func setIsKeyboardVisible(_ value: Bool) {
            isKeyboardVisible = value
        }
        
        func setWebPriceForCurrencyTextField() {
            Task {
                try await Task.sleep(nanoseconds: 250_000_000)
                _wishPrice = wishPriceFromWeb
            }
        }
        
        func fetchDataFromURL() {
            startSearchingThumbnail = true
            guard let _wishLink = _wishLink,
                  let url = URL(string: _wishLink) else { return }
            fetchURLMetadata(from: url) { [weak self] title, uiImage in
                if title != nil {
                    self?._wishName = title ?? ""
                }
                if uiImage != nil {
                    self?.thumbnailImage = uiImage
                }
            }
        }
        
        func loadImageFromURL(_ url: URL) {
            if url.startAccessingSecurityScopedResource() {
                do {
                    let data = try Data(contentsOf: url)
                    Task {
                        wishUIImage = UIImage(data: data)
                    }
                    url.stopAccessingSecurityScopedResource()
                } catch {
                    print("Error loadImageFromURL: ", error.localizedDescription)
                    url.stopAccessingSecurityScopedResource()
                }
            }
        }
        
        func loadMetadataFromWebsiteLink(_ websiteLink: String) {
            _wishLink = websiteLink
            fetchDataFromURL()
        }
        
        func saveNewWish(_ coreDataModel: CoreDataModel, _ currentUser: AuthDataResultModel?) async {
            if let selectedFolder = selectedFolder {
                let newWish = Wish(context: coreDataModel.context)
                newWish.id = UUID()
                newWish.name = _wishName.trimmingCharacters(in: .whitespaces)
                
                if wishUIImage != nil {
                    newWish.image = wishUIImage?.reduceHeight(400).jpegData(compressionQuality: 0.3)
                } else {
                    newWish.image = thumbnailImage?.jpegData(compressionQuality: 1.0)
                }
                
                newWish.initialPrice = Double(_wishPrice) / Double(100)
                
                if _wishLink != nil && _wishLink != "" {
                    newWish.url = _wishLink
                }
                newWish.isFavorite = false
                newWish.createdAt = Date.now
                newWish.folder = selectedFolder
                
                coreDataModel.saveContext()
                coreDataModel.refreshWishes()
            }
        }
        
        func setSelectedFolder(_ folder: Folder) {
            selectedFolder = folder
        }
        
        func hideKeyboardOnReturnPress(_ selectedTextFieldEnum: SelectedTextFieldEnum, _ newValue: String) {
            guard let newValueLastChar = newValue.last else { return }
            if newValueLastChar == "\n" {
                switch selectedTextFieldEnum {
                case .name:
                    _wishName.removeLast()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
}
