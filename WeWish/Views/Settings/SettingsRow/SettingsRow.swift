//
//  SettingsRow.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 03.11.23.
//

import SwiftUI

struct SettingsRow: View {
    
    // MARK: - Properties
    private var rowData: SettingsRowDataModel
    
    init(_ rowData: SettingsRowDataModel) {
        self.rowData = rowData
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            if let uiImageName = rowData.uiImageName {
                Image(uiImage: UIImage(named: uiImageName) ?? UIImage.actions)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(CGFloat(30).getAppIconCornerRadious())
            } else {
                Image(systemName: rowData.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(6)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
                    .background(rowData.imageBackgroundColor)
                    .cornerRadius(CGFloat(30).getAppIconCornerRadious())
            }
            Text(rowData.text)
                .padding(.leading, 8)
            Spacer()
        }
    }
}

#Preview {
    SettingsRow(SettingsRowDataModel(id: 0, 
                                     uiImageName: nil,
                                     imageName: "person.crop.square",
                                     imageBackgroundColor: .red,
                                     text: "Profile"))
}
