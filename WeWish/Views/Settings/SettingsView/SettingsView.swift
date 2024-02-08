//
//  SettingsView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import RevenueCat
import RevenueCatUI
import SwiftUI
import TipKit

struct SettingsView: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @StateObject private var viewModel = ViewModel()
    
    private var editSettingButtonTip = EditSettingButtonTip()
    private var emailHelper = EmailHelper(toAddress: "wishlist@hellowewish.com",
                                          subject: "Report a Bug",
                                          messageHeader: "Please describe your issue below")
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.isEditMode {
                    List {
                        Group {
                            Section {
                                Button {
                                    viewModel.toggleShowPaywallSheet()
                                } label: {
                                    SettingsRow(SettingsRowModel.data[0])
                                }
#if DEBUG
                                Button {
                                    viewModel.toggleShowRevenueCatDebug()
                                } label: {
                                    SettingsRow(SettingsRowModel.data[1])
                                }
#endif
                            }
                            Section {
                                NavigationLink {
                                    WishFoldersView()
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    SettingsRow(SettingsRowModel.data[2])
                                }
                            }
                            Section {
                                NavigationLink {
                                    AppearanceView()
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    SettingsRow(SettingsRowModel.data[3])
                                }
                            }
                            
                            Section {
                                Button {
                                    let appID = 0
                                    let reviewURL = "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review"
                                    
                                    if let url = URL(string: reviewURL) {
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    }
                                } label: {
                                    SettingsRow(SettingsRowModel.data[4])
                                }
                                NavigationLink {
                                    ShareAppView()
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    SettingsRow(SettingsRowModel.data[5])
                                }
                                Button {
                                    emailHelper.send(openURL: openURL)
                                } label: {
                                    SettingsRow(SettingsRowModel.data[6])
                                }
                            }
                            Section {
                                NavigationLink {
                                    AboutView()
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    SettingsRow(SettingsRowModel.data[7])
                                }
                            }
                        }
                        .listSectionSpacing(20)
                        .listRowBackground(CustomColor.whiteAndSystemGray5)
                        .frame(height: 25)
                    }
                    .environment(\.defaultMinListRowHeight, 10)
                    .scrollContentBackground(.hidden)
                    .listStyle(.sidebar)
                } else {
                    VStack {
                        IntroduceTabView(IntroduceTabModel(id: 2,
                                                           mainImageName: "gearshape",
                                                           mainText: "Manage Account"))
                        BottomActionButton({
                            Feedback().impactOccured()
                            Task {
                                do {
                                    try await signInWithAppleManager.signOut()
                                } catch {
                                    fatalError("Error during signOut action in SettingsView: \(error.localizedDescription)")
                                }
                            }
                        }, buttonImageName: "",
                                           buttonText: "Log Out",
                                           buttonColor: .orange)
                        BottomActionButton({
                            signInWithAppleManager.deleteAccount()
                        }, buttonImageName: "person.slash",
                                           buttonText: "Delete Account",
                                           buttonColor: .red)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                }
            }
            .background(Color(uiColor: .systemGray6))
            .navigationTitle(!viewModel.isEditMode ? "Settings" : "Account")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Feedback().impactOccured()
                        viewModel.toggleIsEditMode()
                    } label: {
                        Text(viewModel.isEditMode ? "Done" : "Edit")
                    }
                }
            }
            .sheet(isPresented: viewModel.showPaywallSheet, content: {
                RevenueCatPaywallView()
            })
#if DEBUG
            .debugRevenueCatOverlay(isPresented: viewModel.showRevenueCatDebug)
#endif
        }
    }
}

#Preview {
    SettingsView()
}
