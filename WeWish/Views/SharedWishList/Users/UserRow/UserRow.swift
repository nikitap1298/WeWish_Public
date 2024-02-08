//
//  UserRow.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 15.11.23.
//

import CloudKit
import SwiftUI

struct UserRow: View {
    
    // MARK: - Properties
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var cloudShareManager: CloudShareManager
    @StateObject private var viewModel = ViewModel()
    
    private var folder: Folder
    
    init(_ folder: Folder) {
        self.folder = folder
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(systemName: "person")
            Text(viewModel.fullName + " " + "(\(folder.name ?? ""))")
            Spacer()
        }
        .onAppear {
            Task {
                await viewModel.setFull(coreDataModel, cloudShareManager, folder)
            }
        }
    }
}

//#Preview {
//    UserRow()
//}
