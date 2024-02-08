//
//  OwnedFoldersScrollView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 24.12.23.
//

import SwiftUI

struct OwnedFoldersScrollView: View {
    
    // MARK: - Properties
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @StateObject private var viewModel = ViewModel()
    
    private var sortedFolders: [Folder] {
        return coreDataModel.ownedFolders.sorted { $0.isRoot != $1.isRoot }
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack() {
                    ForEach(sortedFolders, id: \.self) { folder in
                        Button {
                            if coreDataModel.ownedRootFolder == folder || subscriptionManager.hasSubscription {
                                Feedback().notificationOccured(.success)
                                coreDataModel.setSelectedOwnedFolder(folder)
                                viewModel.setScrollPosition(coreDataModel.selectedOwnedFolder)
                                UserDefaults.standard.setValue(folder.name, forKey: UserDefaultsKey.selectedOwnedFolderName)
                            } else {
                                Feedback().notificationOccured(.error)
                                viewModel.toggleShowPaywallSheet()
                            }
                        } label: {
                            VStack {
                                HStack {
                                    Text(folder.name ?? "")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(getFolderForegroundColor(folder))
                                        .padding(.bottom, 0)
                                    
                                    if coreDataModel.isShared(object: folder) {
                                        Image(systemName: "person.2.fill")
                                            .foregroundStyle(getFolderForegroundColor(folder))
                                    }
                                }
                                
                                Divider()
                                    .frame(height: 2)
                                    .overlay(getFolderOverlayColor(folder))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: viewModel.scrollPosition.projectedValue)
            .padding(.top)
            .onAppear {
                viewModel.setScrollPosition(coreDataModel.selectedOwnedFolder)
            }
        }
        .sheet(isPresented: viewModel.showPaywallSheet, content: {
            RevenueCatPaywallView()
        })
    }
    
    private func getFolderForegroundColor(_ folder: Folder) -> Color {
        let isSelected = coreDataModel.selectedOwnedFolder == folder
        
        if coreDataModel.ownedRootFolder == folder {
            return isSelected ? CustomColor.green : .gray
        } else if subscriptionManager.hasSubscription {
            return isSelected ? CustomColor.green : .gray
        } else {
            return .gray
        }
    }

    private func getFolderOverlayColor(_ folder: Folder) -> Color {
        let isSelected = coreDataModel.selectedOwnedFolder == folder
        
        if coreDataModel.ownedRootFolder == folder {
            return isSelected ? CustomColor.green : Color(uiColor: .systemGray6)
        } else if subscriptionManager.hasSubscription {
            return isSelected ? CustomColor.green : Color(uiColor: .systemGray6)
        } else {
            return Color(uiColor: .systemGray6)
        }
    }
}

#Preview {
    OwnedFoldersScrollView()
}
