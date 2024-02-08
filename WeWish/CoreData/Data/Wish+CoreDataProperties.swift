//
//  Wish+CoreDataProperties.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 01.11.23.
//
//

import Foundation
import CoreData


extension Wish {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wish> {
        return NSFetchRequest<Wish>(entityName: "Wish")
    }
    
    @NSManaged public var buyUserId: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var initialPrice: Double
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var folder: Folder?
    
    public var wrappedName: String {
        name ?? "Unknown Wish"
    }
}

extension Wish : Identifiable {
    
}
