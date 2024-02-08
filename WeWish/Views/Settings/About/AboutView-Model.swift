//
//  AboutView-Model.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

struct AboutRowModel: Hashable {
    let id: Int
    let title: String
    let description: String?
}

struct AboutRowData {
    static var data = [
        AboutRowModel(id: 0,
                      title: "Developer",
                      description: "Nikita Pishchugin"),
        AboutRowModel(id: 1,
                      title: "Version",
                      description: UIApplication.appVersion),
        AboutRowModel(id: 2,
                      title: "Terms of Use",
                      description: nil),
        AboutRowModel(id: 3,
                      title: "Privacy Policy",
                      description: nil),
        AboutRowModel(id: 4,
                      title: "Licenses",
                      description: nil)
    ]
}

struct GroupBoxModel {
    let id: Int
    let labelText: String
    let mainText: String
    let navigationTitle: String
}

struct LicensesRowData {
    static var data = [
        AboutRowModel(id: 0,
                      title: "ScrollViewSectionKit",
                      description: nil),
        AboutRowModel(id: 1,
                      title: "SPIndicator",
                      description: nil),
        AboutRowModel(id: 2,
                      title: "SwiftSoup",
                      description: nil),
        AboutRowModel(id: 3,
                      title: "UIDeviceComplete",
                      description: nil)
        ]
}
