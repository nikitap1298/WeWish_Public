//
//  Enums.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 24.11.23.
//

import Foundation

enum SortWishesEnum: String, CaseIterable {
    case byName = "Name"
    case byPrice = "Price (high - low)"
    case byCreatedAt = "Date (new - old)"
}

enum SelectedTextFieldEnum {
    case name
}
