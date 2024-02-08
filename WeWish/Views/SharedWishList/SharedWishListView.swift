//
//  SharedWishListView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 15.11.23.
//

import SwiftUI

struct SharedWishListView: View {
    
    // MARK: - Properties
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @State private var path = NavigationPath()
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                
                if coreDataModel.otherUserFolders.isEmpty {
                    IntroduceTabView(IntroduceTabModel(id: 1,
                                                       mainImageName: "rectangle.stack.badge.person.crop",
                                                       mainText: "Shared"))
                } else {
                    UserList($path)
                }
            }
            .navigationTitle("Shared")
            .navigationDestination(for: SharedNavigationRoutes.self) { routes in
                switch routes {
                case .folderOverview:
                    FolderOverview($path)
                case .wishOverview:
                    WishOverview($path)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    SharedWishListView()
}
