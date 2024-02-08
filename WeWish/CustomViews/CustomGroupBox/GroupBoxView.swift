//
//  GroupBoxView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

struct GroupBoxView: View {
    
    private var groupBoxModel: GroupBoxModel
    
    init(_ groupBoxModel: GroupBoxModel) {
        self.groupBoxModel = groupBoxModel
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            GroupBox(label: Label(groupBoxModel.labelText, systemImage: "building.columns"), content: {
                ScrollView(.vertical) {
                    Text(groupBoxModel.mainText)
                        .font(.footnote)
                }
            })
            .groupBoxStyle(CustomGroupBoxStyle())
            .padding(.vertical)
        }
        .navigationTitle(groupBoxModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GroupBoxView(GroupBoxModel(id: 0,
                                 labelText: "Terms of Use",
                                 mainText: Agreements.termsOfUse,
                                 navigationTitle: "Terms of Use"))
}
