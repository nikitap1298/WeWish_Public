//
//  Folder+CoreDataProperties.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 01.11.23.
//
//

import Foundation
import CoreData


extension Folder {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }
    
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isRoot: Bool
    @NSManaged public var name: String?
    @NSManaged public var ownerId: String?
    
    @NSManaged public var wishes: NSSet?
    
    public var wishArray: [Wish] {
        let set = wishes as? Set<Wish> ?? []
        
        return set.sorted { $0.wrappedName < $1.wrappedName }
    }
}

// MARK: Generated accessors for wishes
extension Folder {
    
    @objc(addWishesObject:)
    @NSManaged public func addToWishes(_ value: Wish)
    
    @objc(removeWishesObject:)
    @NSManaged public func removeFromWishes(_ value: Wish)
    
    @objc(addWishes:)
    @NSManaged public func addToWishes(_ values: NSSet)
    
    @objc(removeWishes:)
    @NSManaged public func removeFromWishes(_ values: NSSet)
    
}

extension Folder : Identifiable {
    
}
