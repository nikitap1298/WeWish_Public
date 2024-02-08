//
//  FolderOverview.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 16.11.23.
//

import SwiftUI

struct FolderOverview: View {
    
    // MARK: - Properties
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var cloudShareManager: CloudShareManager
    @StateObject private var viewModel = ViewModel()
    @Binding var path: NavigationPath
    
    init(_ path: Binding<NavigationPath>) {
        _path = path
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            if coreDataModel.selectedOtherUserFolder?.wishArray.isEmpty == true {
                VStack {
                    Image(systemName: "externaldrive")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Text("This person doesn't have any wishes")
                        .font(.subheadline)
                        .padding(.top, 15)
                }
            } else {
                WishList($path, sharedTab: true, viewModel.selectedSortType)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Text in the back button becomes "Back"
            ToolbarItem(placement: .principal) {
                Text(viewModel.fullName)
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    if !(coreDataModel.selectedOtherUserFolder?.wishArray.isEmpty == true) {
                        Menu {
                            Section("Sort By") {
                                ForEach(SortWishesEnum.allCases, id: \.self) { data in
                                    Button {
                                        viewModel.setSelectedSortType(data.rawValue)
                                    } label: {
                                        HStack {
                                            Text(data.rawValue)
                                            Spacer()
                                            if viewModel.selectedSortType == data.rawValue {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            }
                        } label: {
                            Button(action: {}, label: {
                                Image(systemName: "arrow.up.arrow.down")
                            })
                        }
                        .onTapGesture {
                            Feedback().impactOccured()
                        }
                    }
                    Button {
                        Feedback().impactOccured()
                        if let folder = coreDataModel.selectedOtherUserFolder {
                            if coreDataModel.isShared(object: folder) {
                                cloudShareManager.setFolderShare(coreDataModel, folder)
                            }
                            viewModel.toggleShowShareSheet()
                        }
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
        .sheet(isPresented: viewModel.showShareSheet, content: {
            if let folder = coreDataModel.selectedOtherUserFolder {
                if let share = cloudShareManager.share {
                    CloudSharingView(
                        share: share,
                        container: coreDataModel.ckContainer,
                        folder: folder
                    )
                    .ignoresSafeArea(.all)
                }
            }
        })
        .onAppear {
            if let selectedOtherUserFolder = coreDataModel.selectedOtherUserFolder {
                cloudShareManager.setFolderShare(coreDataModel, selectedOtherUserFolder)
                Task {
                    await viewModel.setFull(coreDataModel, cloudShareManager, selectedOtherUserFolder)
                }
                guard let selectedSharedWishesSortType = UserDefaults.standard.value(forKey: UserDefaultsKey.selectedSharedWishesSortType) as? String else { return }
                viewModel.setSelectedSortType(selectedSharedWishesSortType)
            }
        }
    }
}

//#Preview {
//    FolderOverview()
//}
