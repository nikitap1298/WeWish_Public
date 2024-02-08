//
//  WishCoreDataProtocol.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import SwiftUI

protocol WishCoreDataProtocol {
    func updateIsFavoriteProperty(_ coreDataModel: CoreDataModel, _ wish: Wish) async
    func updateInitialPrice(_ coreDataModel: CoreDataModel, _ wish: Wish, _ newPrice: Double) async
    func updateBuyUserId(_ coreDataModel: CoreDataModel, _ wish: Wish, _ userId: String?) async
    func deleteWish(_ coreDataModel: CoreDataModel,_ wish: Wish) async
}

extension WishCoreDataProtocol {
    @MainActor func updateIsFavoriteProperty(_ coreDataModel: CoreDataModel, _ wish: Wish) async {
        // Only owner can update
        if coreDataModel.isOwner(object: wish) {
            wish.isFavorite.toggle()
            coreDataModel.saveContext()
            coreDataModel.refreshWishes()
        }
    }
    
    @MainActor func updateInitialPrice(_ coreDataModel: CoreDataModel, _ wish: Wish, _ newPrice: Double) async {
        // Only owner can update
        if coreDataModel.isOwner(object: wish) {
            wish.initialPrice = newPrice
            coreDataModel.saveContext()
            coreDataModel.refreshWishes()
        }
    }
    
    @MainActor func updateBuyUserId(_ coreDataModel: CoreDataModel, _ wish: Wish, _ userId: String?) async {
        // Every user except owner can update
        if !coreDataModel.isOwner(object: wish) {
            wish.buyUserId = userId
            coreDataModel.saveContext()
            coreDataModel.refreshWishes()
        }
    }
    
    @MainActor func deleteWish(_ coreDataModel: CoreDataModel,_ wish: Wish) async {
        // Only owner can delete
        if coreDataModel.isOwner(object: wish) {
            coreDataModel.context.delete(wish)
            coreDataModel.saveContext()
        }
    }
}
