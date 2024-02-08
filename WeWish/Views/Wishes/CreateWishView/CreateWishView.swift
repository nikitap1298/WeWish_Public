//
//  CreateWishView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import PhotosUI
import SwiftUI
import SwiftSoup

struct CreateWishView: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @StateObject private var viewModel = ViewModel()
    
    private var imageURL: URL?
    private var websiteLink: String?
    
    init(_ imageURL: URL?, _ websiteLink: String?) {
        self.imageURL = imageURL
        self.websiteLink = websiteLink
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
                            TextField(text: viewModel.wishName, axis: .vertical) {
                                Text("iPhone")
                            }
                            .submitLabel(.done)
                            // Custom functionallity which hides the keyboard on return press
                            .onChange(of: viewModel._wishName, { _, newValue in
                                viewModel.hideKeyboardOnReturnPress(.name, newValue)
                            })
                        } header: {
                            HStack {
                                Text("Name")
                                    .textCase(.uppercase)
                                Text("*")
                                    .font(.body)
                                    .foregroundStyle(Color.red)
                                Spacer()
                            }
                        }
                        
                        Section {
                            HStack {
                                PhotosPicker("Select image", selection: viewModel.wishItem, matching: .images)
                                    .onChange(of: viewModel.wishUIImage) { _, _ in
                                        viewModel.setThumbnailImage(nil)
                                    }
                            }
                        } header: {
                            Text("Image")
                                .textCase(.uppercase)
                        }
                        
                        if viewModel.wishUIImage != nil {
                            Section {
                                HStack {
                                    Spacer()
                                    Image(uiImage: viewModel.wishUIImage ?? UIImage.add)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 150)
                                        .padding(.vertical, 10)
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Button {
                                        viewModel.setWishUIImage(nil)
                                    } label: {
                                        Text("Remove image")
                                            .foregroundStyle(Color.red)
                                    }
                                    Spacer()
                                }
                            } footer: {
                                Text("Remove image if you want to find a new image from the website link")
                            }
                        } else if viewModel._wishLink != "" && viewModel.startSearchingThumbnail == true {
                            Section {
                                HStack {
                                    Spacer()
                                    if let thumbnailImage = viewModel.thumbnailImage {
                                        Image(uiImage: thumbnailImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                                            }
                                            .frame(maxWidth: 150, maxHeight: 150)
                                            .padding(.vertical, 10)
                                    } else {
                                        ProgressView()
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                        Section {
                            CurrencyTextField(numberFormatter: formatter(),
                                              value: viewModel.wishPrice)
                            .frame(maxHeight: 20)
                            .id(viewModel.updateCurrencyTextField)
                            .onChange(of: viewModel.updateCurrencyTextField) { _, _ in
                                viewModel.setWebPriceForCurrencyTextField()
                            }
                        } header: {
                            Text("Price")
                                .textCase(.uppercase)
                        }
                        
                        Section {
                            TextField(text: viewModel.wishLink) {
                                Text("apple.com")
                            }
                            .keyboardType(.URL)
                            .submitLabel(.search)
                            .textInputAutocapitalization(.never)
                            .onSubmit {
                                if viewModel.wishUIImage == nil {
                                    viewModel.fetchDataFromURL()
                                }
                            }
                        } header: {
                            Text("Website link")
                                .textCase(.uppercase)
                        } footer: {
                            Text("Click the search button on the keyboard to start searching for the name and image from the link")
                        }
                    }
                    .iPadPadding(.zero)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .tint(.accentColor)
                                    .font(.title2)
                            })
                        }
                    }
                    
                    BottomActionButton({
                        if viewModel._wishName != "" {
                            Task {
                                await viewModel.saveNewWish(coreDataModel, signInWithAppleManager.user)
                            }
                            Feedback().notificationOccured(.success)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            Feedback().notificationOccured(.error)
                            viewModel.setShowFillNameAlert()
                        }
                    }, buttonImageName: "plus.rectangle.on.rectangle",
                                       buttonText: "Add",
                                       buttonColor: .blue
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Menu {
                        ForEach(coreDataModel.ownedFolders) { folder in
                            Button {
                                viewModel.setSelectedFolder(folder)
                            } label: {
                                HStack {
                                    Text(folder.name ?? "")
                                    Spacer()
                                    if viewModel.selectedFolder == folder {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            .disabled(!subscriptionManager.hasSubscription)
                        }
                    } label: {
                        HStack {
                            Text("Add Wish")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.caption)
                        }
                        .foregroundStyle(CustomColor.blackAndWhite)
                    }
                }
            }
            .onAppear {
                if let imageURL = imageURL {
                    viewModel.loadImageFromURL(imageURL)
                } else if let websiteLink = websiteLink {
                    viewModel.loadMetadataFromWebsiteLink(websiteLink)
                }
                
                guard let selectedOwnedFolder = coreDataModel.selectedOwnedFolder else { return }
                viewModel.setSelectedFolder(selectedOwnedFolder)
            }
            .onChange(of: viewModel._wishItem, { _, _ in
                Task {
                    if let data = try? await viewModel._wishItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            viewModel.setWishUIImage(uiImage)
                            return
                        }
                    }
                    print("error picking image")
                }
            })
            .alert("Enter the Name", isPresented: viewModel.showFillNameAlert) {
                Button("Ok", role: .cancel) { }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                viewModel.setIsKeyboardVisible(true)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                viewModel.setIsKeyboardVisible(false)
            }
            .onDisappear {
                viewModel.setThumbnailImage(nil)
            }
        }
        .blur(radius: viewModel._showFillNameAlert ? 2.0 : 0.0)
    }
}

#Preview {
    CreateWishView(nil, nil)
}
