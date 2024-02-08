//
//  SettingsView-Model.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

struct SettingsRowDataModel {
    let id: Int
    let uiImageName: String?
    let imageName: String
    let imageBackgroundColor: Color?
    let text: String
}


struct SettingsRowModel {
    static var data = [
        SettingsRowDataModel(id: 0,
                             uiImageName: "AppIcon",
                             imageName: "",
                             imageBackgroundColor: nil,
                             text: "WeWish Pro"),
        SettingsRowDataModel(id: 1,
                             uiImageName: nil,
                             imageName: "hammer.fill",
                             imageBackgroundColor: .gray,
                             text: "RevenueCat Debug"),
        SettingsRowDataModel(id: 2,
                             uiImageName: nil,
                             imageName: "folder.fill",
                             imageBackgroundColor: .blue,
                             text: "Wish Folders"),
        SettingsRowDataModel(id: 3,
                             uiImageName: nil,
                             imageName: "circle.lefthalf.filled.inverse",
                             imageBackgroundColor: .blue,
                             text: "Appearance"),
        SettingsRowDataModel(id: 4,
                             uiImageName: nil,
                             imageName: "star.fill",
                             imageBackgroundColor: .yellow,
                             text: "Rate App"),
        SettingsRowDataModel(id: 5,
                             uiImageName: nil,
                             imageName: "square.and.arrow.up.fill",
                             imageBackgroundColor: .green,
                             text: "Share App"),
        SettingsRowDataModel(id: 6,
                             uiImageName: nil,
                             imageName: "exclamationmark.triangle.fill",
                             imageBackgroundColor: .red,
                             text: "Report a Bug"),
        SettingsRowDataModel(id: 7,
                             uiImageName: nil,
                             imageName: "info.circle.fill",
                             imageBackgroundColor: .gray,
                             text: "About WeWish"),
    ]
}
