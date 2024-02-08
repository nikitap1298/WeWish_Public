//
//  UserList.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 15.11.23.
//

import SwiftUI

struct UserList: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var cloudShareManager: CloudShareManager
    @Binding var path: NavigationPath
    
    init(_ path: Binding<NavigationPath>) {
        _path = path
    }
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(coreDataModel.otherUserFolders) { folder in
                if cloudShareManager.getFolderShare(coreDataModel, folder)?.owner != nil {
                    Button(action: {
                        path.append(SharedNavigationRoutes.folderOverview)
                        coreDataModel.selectedOtherUserFolder = folder
                    }, label: {
                        UserRow(folder)
                    })
                }
            }
            .listRowBackground(colorScheme == .light ? .white : Color(uiColor: .systemGray5))
            .frame(height: 25)
        }
        .environment(\.defaultMinListRowHeight, 10)
        .background(Color(uiColor: .systemGray6))
        .scrollContentBackground(.hidden)
        .listStyle(.sidebar)
    }
}

//#Preview {
//    UserList()
//}
