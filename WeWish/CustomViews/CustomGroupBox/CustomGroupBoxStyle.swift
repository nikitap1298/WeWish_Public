//
//  CustomGroupBoxStyle.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

struct CustomGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        .background(CustomColor.whiteAndSystemGray5)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
