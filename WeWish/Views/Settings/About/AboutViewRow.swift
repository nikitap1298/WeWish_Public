//
//  AboutViewRow.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

struct AboutViewRow: View {
    
    // MARK: - Properties
    private var rowData: AboutRowModel
    
    init(_ rowData: AboutRowModel) {
        self.rowData = rowData
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            Text(rowData.title)
            Spacer()
            Text(rowData.description ?? "")
                .font(.callout)
                .fontWeight(.light)
        }
        .foregroundStyle(CustomColor.blackAndWhite)
    }
}

#Preview {
    AboutViewRow(AboutRowModel(id: 0,
                               title: "Developer",
                               description: "Nikita Pishchugin"))
}
