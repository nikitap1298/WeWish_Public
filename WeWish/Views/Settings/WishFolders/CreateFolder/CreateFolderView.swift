//
//  CreateFolderView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 27.11.23.
//

import SwiftUI

struct CreateFolderView: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @StateObject private var viewModel = ViewModel()
    
    @State private var selectedWishes = Set<Wish>()
    
    private var sortedSelectedWishes: [Wish] {
        return Array(selectedWishes).sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: UIColor.systemGray6)
                    .ignoresSafeArea()
                VStack {
                    Form {
                        Section {
                            TextField(text: viewModel.folderName, axis: .vertical) {
                                Text("Christmas")
                            }
                            .submitLabel(.done)
                            // Custom functionallity which hides the keyboard on return press
                            .onChange(of: viewModel._folderName, { _, newValue in
                                viewModel.hideKeyboardOnReturnPress(.name, newValue)
                            })
                        } header: {
                            HStack {
                                Text("Folder Name")
                                    .textCase(.uppercase)
                                Text("*")
                                    .font(.body)
                                    .foregroundStyle(Color.red)
                                Spacer()
                            }
                        }
                        if !coreDataModel.ownedFolders.isEmpty {
                            Section {
                                HStack {
                                    Button {
                                        Feedback().impactOccured()
                                        viewModel.toggleShowIncludeWishesSheet()
                                    } label: {
                                        HStack {
                                            Image(systemName: "plus")
                                            Text("Add Wishes")
                                        }
                                    }
                                }
                                ForEach(sortedSelectedWishes, id: \.self) { wish in
                                    HStack {
                                        Text(wish.name ?? "")
                                        Spacer()
                                        Button {
                                            selectedWishes.remove(wish)
                                        } label: {
                                            Image(systemName: "xmark.circle")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                }
                            } header: {
                                Text("Import Wishes")
                                    .textCase(.uppercase)
                            } footer: {
                                Text("Choose wishes that will be imported to this folder")
                            }
                        }
                    }
                    .scrollDisabled(true)
                    .scrollViewSectionStyle(.insetGrouped)
                    .scrollViewSectionBackgroundColor(.clear)
                    .scrollViewRowBackgroundColor(colorScheme == .light ? .white : .black)
                    .iPadPadding(.zero)
                    
                    BottomActionButton({
                        if viewModel._folderName != "" {
                            Task {
                                await viewModel.createNewFolder(coreDataModel, signInWithAppleManager.user, selectedWishes)
                            }
                            Feedback().notificationOccured(.success)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            Feedback().notificationOccured(.error)
                            viewModel.toggleShowFillNameAlert()
                        }
                    }, buttonImageName: "folder.badge.plus",
                                       buttonText: "Add",
                                       buttonColor: .blue
                    )
                }
            }
            .navigationTitle("Add Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .tint(.accentColor)
                            .font(.title2)
                    }
                }
            }
            .alert("Enter the Name", isPresented: viewModel.showFillNameAlert) {
                Button("Ok", role: .cancel) { }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                viewModel.setIsKeyboardVisible(true)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                viewModel.setIsKeyboardVisible(false)
            }
            .sheet(isPresented: viewModel.showIncludeWishesSheet) {
                IncludeWishesView(selectedWishes: $selectedWishes)
            }
        }
        .blur(radius: viewModel._showFillNameAlert ? 2.0 : 0.0)
    }
}

#Preview {
    CreateFolderView()
}
