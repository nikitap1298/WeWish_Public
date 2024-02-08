//
//  WishRow-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 20.12.23.
//

import SwiftUI

extension WishRow {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var isOwner = false
        
        func setIsOwner(_ coreDataModel: CoreDataModel, _ wish: Wish) {
            isOwner = coreDataModel.isOwner(object: wish)
        }
    }
}
