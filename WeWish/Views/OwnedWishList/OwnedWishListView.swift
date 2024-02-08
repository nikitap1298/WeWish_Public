//
//  OwnedWishListView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 15.11.23.
//

import StoreKit
import SwiftUI
import TipKit

struct OwnedWishListView: View {
    
    // MARK: - Properties
    @Environment(\.requestReview) var requestReview
    @AppStorage(AppStorageKeys.numberOfAppLaunches) private var numberOfAppLaunches = 0
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @EnvironmentObject private var cloudShareManager: CloudShareManager
    @StateObject private var viewModel = ViewModel()
    @State private var path = NavigationPath()
    
    private var shareFolderTip = ShareFolderTip()
    
    init() {
      UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.clear]
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                VStack {
                    OwnedFoldersScrollView()
                    if !(coreDataModel.selectedOwnedFolder?.wishArray.isEmpty ?? true) {
                        WishList($path, sharedTab: false, viewModel.selectedSortType)
                    } else {
                        IntroduceTabView(IntroduceTabModel(id: 0,
                                                           mainImageName: "sparkles.rectangle.stack",
                                                           mainText: "My Wishes"))
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            Feedback().impactOccured()
                            viewModel.toggleShowCreateWishSheet()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title.weight(.semibold))
                                .padding()
                                .background(CustomColor.green)
                                .foregroundStyle(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 4)
                            
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(coreDataModel.selectedOwnedFolder?.name ?? "My Wishes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !(coreDataModel.selectedOwnedFolder?.wishArray.isEmpty ?? true) {
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
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Feedback().impactOccured()
                        if subscriptionManager.hasSubscription {
                            if let folder = coreDataModel.selectedOwnedFolder {
                                if !coreDataModel.isShared(object: folder) {
                                    Task {
                                        viewModel.setShowProgressView(true)
                                        try await Task.sleep(nanoseconds: 2_000_000_000)
                                        await viewModel.createShare(folder) { ckshare in
                                            cloudShareManager.setShare(ckshare)
                                        }
                                        viewModel.toggleShowShareSheet()
                                        viewModel.setShowProgressView(false)
                                    }
                                } else {
                                    if let ownedFolder = coreDataModel.selectedOwnedFolder {
                                        cloudShareManager.setFolderShare(coreDataModel, ownedFolder)
                                    }
                                    viewModel.toggleShowShareSheet()
                                    viewModel.setShowProgressView(false)
                                }
                            }
                        } else {
                            viewModel.toggleShowPaywallSheet()
                        }
                    } label: {
                        if !viewModel.showProgressView {
                            Image(systemName: "square.and.arrow.up")
//                                    .symbolRenderingMode(.multicolor)
                        } else {
                            ProgressView()
                        }
                    }
                    .popoverTip(shareFolderTip, arrowEdge: .top)
                }
            }
            .sheet(isPresented: viewModel.showShareSheet, content: {
                if let folder = coreDataModel.selectedOwnedFolder {
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
            .sheet(isPresented: viewModel.showCreateWishSheet) {
                CreateWishView(viewModel.imageURL, viewModel.websiteLink)
            }
            .sheet(isPresented: viewModel.showPaywallSheet, content: {
                RevenueCatPaywallView()
            })
            .onAppear {
                numberOfAppLaunches += 1
#if !DEBUG
                if numberOfAppLaunches >= 5 {
                    requestReview()
                }
#endif
                guard let selectedOwnedWishesSortType = UserDefaults.standard.value(forKey: UserDefaultsKey.selectedOwnedWishesSortType) as? String else { return }
                viewModel.setSelectedSortType(selectedOwnedWishesSortType)
            }
            .onOpenURL(perform: { _ in
                viewModel.handleURL()
            })
            .task {
                // Configure and load your tips at app launch.
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
            }
            .navigationDestination(for: OwnedNavigationRoutes.self) { route in
                switch route {
                case .wishOverview:
                    WishOverview($path)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    OwnedWishListView()
}
