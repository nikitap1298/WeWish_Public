//
//  EditWishView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 11.11.23.
//

import PhotosUI
import SwiftUI

struct EditWishView: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @StateObject private var viewModel = ViewModel()
    
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
                        
                        if viewModel.showCurrencyTextField {
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
                    
                    BottomActionButton({
                        Task {
                            await viewModel.updateWish(coreDataModel)
                        }
                        Feedback().notificationOccured(.success)
                        presentationMode.wrappedValue.dismiss()
                    }, buttonImageName: "arrow.circlepath",
                                       buttonText: "Update",
                                       buttonColor: .blue
                    )
                }
            }
            .navigationTitle("Edit Wish")
            .navigationBarTitleDisplayMode(.inline)
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
            .onAppear {
                viewModel.setAllSections(coreDataModel)
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
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                viewModel.setIsKeyboardVisible(true)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                viewModel.setIsKeyboardVisible(false)
            }
        }
    }
}

#Preview {
    EditWishView()
}
