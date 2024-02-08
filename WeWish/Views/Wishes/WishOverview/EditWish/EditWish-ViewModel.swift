//
//  EditWish-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 13.11.23.
//

import PhotosUI
import SwiftUI

extension EditWishView {
    @MainActor class ViewModel: ObservableObject, ThumbnailProtocol {
        
        // MARK: - Properties
        @Published private(set) var _wishName = ""
        @Published private(set) var _wishItem: PhotosPickerItem?
        @Published private(set) var wishUIImage: UIImage?
        private var _wishPrice = 0
        @Published private(set) var _wishLink: String?
        @Published private(set) var showCurrencyTextField = false
        @Published private(set) var thumbnailImage: UIImage?
        @Published private(set) var startSearchingThumbnail = false
        @Published private(set) var _showFillNameAlert = false
        @Published private(set) var isKeyboardVisible = false
        private(set) var updateCurrencyTextField = false
        private var wishPriceFromWeb = 0
        
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
        
        func setAllSections(_ coreDataModel: CoreDataModel) {
            guard let selectedWish = coreDataModel.selectedWish else { return }
            
            _wishName = selectedWish.name ?? ""
        
            if let image = selectedWish.image {
                wishUIImage = UIImage(data: (image))
            }
            
            _wishPrice = Int(round(selectedWish.initialPrice * 100))
            _wishLink = coreDataModel.selectedWish?.url
            
            showCurrencyTextField = true
        }
        
        func updateWish(_ coreDataModel: CoreDataModel) async {
            
            // Only owner can update
            if let selectedWish = coreDataModel.selectedWish {
                if coreDataModel.isOwner(object: selectedWish) {
                    coreDataModel.selectedWish?.name = _wishName.trimmingCharacters(in: .whitespaces)
                    
                    if wishUIImage != nil {
                        coreDataModel.selectedWish?.image = wishUIImage?.reduceHeight(400).jpegData(compressionQuality: 0.3)
                    } else {
                        coreDataModel.selectedWish?.image = thumbnailImage?.jpegData(compressionQuality: 0.5)
                    }
                    
                    coreDataModel.selectedWish?.initialPrice = Double(_wishPrice) / Double(100)
                    
                    coreDataModel.selectedWish?.url = _wishLink == "" ? nil : _wishLink
                    
                    coreDataModel.saveContext()
                    coreDataModel.refreshWishes()
                }
            }
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
