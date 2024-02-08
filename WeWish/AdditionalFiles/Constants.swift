//
//  Constants.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import Foundation
import SwiftUI

struct UserDefaultsKey {
    static let isFirstLaunch = "IsFirstLaunch"
    static let selectedOwnedFolderName = "SelectedOwnedFolderName"
    static let selectedFolderName = "SelectedFolderName"
    static let selectedOwnedWishesSortType = "SelectedOwnedWishesSortType"
    static let selectedSharedWishesSortType = "SelectedSharedWishesSortType"
}


struct CustomColor {
    static let blackAndWhite = Color(uiColor: .init(named: "Black&White") ?? .black)
    static let green = Color("CustomGreen")
    static let whiteAndBlack = Color(uiColor: .init(named: "White&Black") ?? .white)
    static let whiteAndSystemGray5 = Color(uiColor: .init(named: "White&SystemGray5") ?? .white)
    static let whiteAndSystemGray6 = Color(uiColor: .init(named: "White&SystemGray6") ?? .white)
}

struct AssetImage {
    static let folder = UIImage(named: "Folder")
}

struct AppStorageKeys {
    static let currentAppearanceType = "CurrentAppearanceType"
    static let numberOfAppLaunches = "NumberOfAppLaunches"
}

struct NotificationNames {
    static let shareSuccessfullyAccepted = NSNotification.Name("ShareSuccessfullyAccepted")
    static let errorDuringAcceptingShare = NSNotification.Name("ErrorDuringAcceptingShare")
}
