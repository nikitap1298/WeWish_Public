//
//  WishFoldersView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 27.11.23.
//

import SwiftUI

struct WishFoldersView: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @StateObject private var viewModel = ViewModel()
    
    private var sortedOwnedFolders: [Folder] {
        return coreDataModel.ownedFolders.sorted { $0.isRoot && !$1.isRoot }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack{
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            List {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "folder.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .padding(.bottom, 20)
                            .foregroundStyle(.blue.gradient)
                        Text("Create folders for different groups of wishes and quickly switch between them on \"My Wishes\" tab.")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                        
                        if !subscriptionManager.hasSubscription {
                            Text("* Subscription required.")
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .padding(.top, 4)
                        }
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
                Section {
                    Button(action: {
                        if subscriptionManager.hasSubscription {
                            Feedback().impactOccured()
                            viewModel.toggleCreateNewFolderSheet()
                        } else {
                            viewModel.toggleShowPaywallSheet()
                        }
                    }, label: {
                        Text("Create a Folder")
                            .foregroundStyle(.blue)
                    })
                    ForEach(sortedOwnedFolders, id: \.self) { folder in
                        HStack {
                            Text(folder.name ?? "")
                            if folder.isRoot {
                                Image(systemName: "info.circle")
                                    .onTapGesture {
                                        viewModel.toggleShowRootFolderInfoAlert()
                                    }
                            }
                            Spacer()
                            Image(systemName: coreDataModel.isShared(object: folder) ? "person.2.fill" : "")
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            if !folder.isRoot {
                                Button(role: .destructive) {
                                    viewModel.setSwipedFolderAndNewFolderName(folder)
                                    viewModel.toggleShowDeleteAlert()
                                } label: {
                                    Text("Delete")
                                }
                                Button {
                                    viewModel.setSwipedFolderAndNewFolderName(folder)
                                    viewModel.toggleShowRenameAlert()
                                } label: {
                                    Text("Rename")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                } header: {
                    Text("Folders")
                        .textCase(.uppercase)
                } footer: {
                    if coreDataModel.ownedFolders.count >= 2 {
                        Text("Swipe left to manage folder")
                    }
                }
                .listSectionSpacing(20)
                .listRowBackground(colorScheme == .light ? .white : Color(uiColor: .systemGray5))
                .frame(height: 25)
            }
            .background(Color(uiColor: .systemGray6))
            .scrollContentBackground(.hidden)
            .environment(\.defaultMinListRowHeight, 10)
            .listStyle(.sidebar)
            .iPadPadding(.eight)
            .blur(radius: viewModel._showRenameAlert
                  || viewModel._showDeleteAlert
                  || viewModel._showRootFolderInfoAlert ? 2.0 : 0.0)
        }
        .navigationTitle("Folders")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: viewModel.showCreateFolderSheet) {
            CreateFolderView()
        }
        .sheet(isPresented: viewModel.showPaywallSheet, content: {
            RevenueCatPaywallView()
        })
        .alert("Enter New Name", isPresented: viewModel.showRenameAlert) {
            TextField("", text: viewModel.newFolderName)
            Button(role: .cancel) {
            } label: {
                Text("Cancel")
            }
            Button(role: .destructive) {
                Task {
                    guard let swipedFolder = viewModel.swipedFolder else { return }
                    await viewModel.updateName(coreDataModel, swipedFolder, viewModel._newFolderName)
                }
            } label: {
                Text("Rename")
            }
            .disabled(viewModel._newFolderName == "")
        }
        .alert("Delete " + "\"\(viewModel.swipedFolder?.name ?? "Folder")\"?", isPresented: viewModel.showDeleteAlert, actions: {
            Button(role: .cancel) {
            } label: {
                Text("Cancel")
            }
            Button(role: .destructive) {
                Task {
                    guard let swipedFolder = viewModel.swipedFolder else { return }
                    await viewModel.deleteFolder(coreDataModel, swipedFolder)
                }
                if coreDataModel.selectedOwnedFolder == viewModel.swipedFolder {
                    guard let ownedRootFolder = coreDataModel.ownedRootFolder else { return }
                    coreDataModel.setSelectedOwnedFolder(ownedRootFolder)
                }
            } label: {
                Text("Delete")
            }
        }, message: {
            Text("You will no longer have access to this folder.")
        })
        .alert("Wishlist Folder", isPresented: viewModel.showRootFolderInfoAlert, actions: {
            Button(role: .cancel) {
            } label: {
                Text("Ok")
            }
        }, message: {
            Text("This is the main folder that was created during your registration. It cannot be renamed or deleted at this moment.")
        })
    }
}

#Preview {
    WishFoldersView()
}
