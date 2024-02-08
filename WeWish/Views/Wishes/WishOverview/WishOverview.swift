//
//  WishOverview.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import Charts
// Doc: https://iosexample.com/a-swiftui-library-that-allows-you-to-add-native-or-custom-section-styles-within-the-scrollview-swiftui-component/
import ScrollViewSectionKit
import SwiftUI
import TipKit
import UniformTypeIdentifiers

struct WishOverview: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var cloudShareManager: CloudShareManager
    @StateObject private var viewModel = ViewModel()
    @Binding var path: NavigationPath
    
    private var iWillBuyButtonTip = IWillBuyButtonTip()
    
    init(_ path: Binding<NavigationPath>) {
        _path = path
    }
    
    // MARK: - Body
    var body: some View {
        if let selectedWish = coreDataModel.selectedWish {
            VStack {
                ZStack {
                    VStack {
                        ScrollView {
                            if let wishImage = selectedWish.image,
                               let image = UIImage(data: wishImage) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(UIDevice.current.userInterfaceIdiom == .pad ? 10 : 0)
                                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width - 200 : UIScreen.main.bounds.width)
                            }
                            
                            Group {
                                HStack {
                                    Text(selectedWish.name ?? "")
                                        .font(.system(size: 30))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(.vertical)
                                
                                if !viewModel.isOwner && selectedWish.buyUserId != nil && selectedWish.buyUserId != signInWithAppleManager.user?.uid {
                                } else {
                                    HStack {
                                        Text(viewModel.currentPrice, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.gray)
                                            .contentTransition(.numericText(value: viewModel.currentPrice))
                                        Spacer()
                                    }
                                }
                                
                                HStack {
                                    if let wishURL = selectedWish.url {
                                        HStack {
                                            Image(systemName: "link")
                                            Link(wishURL.extractDomain() ?? wishURL, destination: URL(string: wishURL)!)
                                                .lineLimit(1)
                                                .font(.system(size: 15))
                                                .foregroundStyle(CustomColor.blackAndWhite)
                                        }
                                    }
                                    if viewModel.numberOfUsers >= 3 {
                                        HStack {
                                            if selectedWish.url != nil {
                                                Divider()
                                                    .overlay(.gray)
                                            }
                                            Image(systemName: "person.2.fill")
                                            Text("\(viewModel.numberOfUsers - 1) users")
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 25)
                            }
                            .iPadPadding(.noValue)
                        }
                        
                        VStack {
                            if viewModel.isOwner {
                                BottomActionButton({
                                    Feedback().impactOccured()
                                    viewModel.toggleShowCompleteConfirmationSheet()
                                }, buttonImageName: "storefront",
                                                   buttonText: "Remove",
                                                   buttonColor: .red)
                            } else {
                                if viewModel.numberOfUsers >= 3 {
                                    if selectedWish.buyUserId == signInWithAppleManager.user?.uid {
                                        BottomActionButton({
                                            Feedback().impactOccured()
                                            Task {
                                                await viewModel.updateBuyUserId(coreDataModel, selectedWish, nil)
                                            }
                                        }, buttonImageName: "bookmark.slash",
                                                           buttonText: "I won't buy",
                                                           buttonColor: .red)
                                    } else if selectedWish.buyUserId == nil {
                                        TipView(iWillBuyButtonTip, arrowEdge: .bottom)
                                            .tipBackground(CustomColor.whiteAndSystemGray5)
                                            .iPadPadding(.noValue)
                                        BottomActionButton({
                                            Feedback().impactOccured()
                                            if let currentUserId = signInWithAppleManager.user?.uid {
                                                viewModel.handleIWillBuy(coreDataModel, selectedWish, currentUserId)
                                            }
                                        }, buttonImageName: "bookmark",
                                                           buttonText: "I'll buy",
                                                           buttonColor: .green)
                                    } else {
                                    }
                                }
                            }
                        }
                        .offset(y: viewModel.animateBottomButton ? 0 : 200)
                        .animation(.easeInOut(duration: 0.35), value: viewModel.animateBottomButton)
                    }
                    .ignoresSafeArea(.keyboard)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        if viewModel.isOwner {
                            Button(action: {
                                Feedback().notificationOccured(.success)
                                Task {
                                    await viewModel.updateIsFavoriteProperty(coreDataModel, selectedWish)
                                }
                            }, label: {
                                Image(systemName: selectedWish.isFavorite ? "star.fill" : "star")
                                    .foregroundStyle(Color.yellow)
                            })
                            .padding(.trailing, 8)
                        }
                        Menu {
                            Section {
                                if viewModel.isOwner {
                                    Button(action: {
                                        viewModel.toggleShowEditWishSheet()
                                    }, label: {
                                        HStack {
                                            Text("Edit")
                                            Image(systemName: "square.and.pencil")
                                        }
                                    })
                                }
                                
                                Button(action: {
                                    Feedback().impactOccured()
                                    viewModel.setPDFURL(renderPDFFromSwiftUIView(WishToPDFView(selectedWish), "\(selectedWish.name ?? "wish").pdf"))
                                    viewModel.toggleActivityVC()
                                }, label: {
                                    HStack {
                                        Text("Share")
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                })
                            }
                            
                            if let wishURL = selectedWish.url {
                                Section {
                                    Button(action: {
                                        Feedback().impactOccured()
                                        UIPasteboard.general.setValue(wishURL, forPasteboardType: UTType.plainText.identifier)
                                    }, label: {
                                        HStack {
                                            Text("Copy Wish Link")
                                            Image(systemName: "link")
                                        }
                                    })
                                    Button(action: {
                                        Feedback().impactOccured()
                                        if let url = URL(string: wishURL), UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    }, label: {
                                        HStack {
                                            Link("Open in Browser", destination: URL(string: wishURL)!)
                                            Image(systemName: "safari")
                                        }
                                    })
                                }
                            }
                        } label: {
                            Button(action: {}, label: {
                                Image(systemName: "ellipsis.circle")
                            })
                        }
                        .onTapGesture {
                            Feedback().impactOccured()
                        }
                        .sheet(isPresented: viewModel.showActivityVC) {
                            if let pdfURL = viewModel.pdfURL {
                                ActivityViewController(activityItems: [pdfURL])
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.visible)
                                    .edgesIgnoringSafeArea(.bottom)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: viewModel.showEditWishSheet, content: {
                EditWishView()
                    .interactiveDismissDisabled(true)
            })
            .onAppear {
                viewModel.setCurrentPrice(selectedWish.initialPrice)
                viewModel.setIsOwner(coreDataModel)
                
                viewModel.setNumberOfUsers(cloudShareManager.numberOfUsers(coreDataModel, selectedWish))
                
                viewModel.setAnimateBottomButton(true)
            }
            .onChange(of: selectedWish.initialPrice) { _, newValue in
                viewModel.setCurrentPrice(newValue)
            }
            .alert("Remove " + "\"\(selectedWish.name ?? "Wish")\"?", isPresented: viewModel.showCompleteConfirmationSheet, actions: {
                Button(role: .cancel) {
                } label: {
                    Text("Cancel")
                }
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteWish(coreDataModel, selectedWish)
                    }
                    path.popToRoot()
                } label: {
                    Text("Remove")
                        .foregroundStyle(.red)
                }
            }, message: {
                Text("You will no longer have access to this wish.")
            })
            .blur(radius: viewModel._showCompleteConfirmationSheet ? 2.0 : 0.0)
        }
    }
    
    private func handleURL(_ url: URL) -> OpenURLAction.Result {
        UIApplication.shared.open(url)
        return .handled
    }
}

//#Preview {
//    WishOverview(Wish())
//}
