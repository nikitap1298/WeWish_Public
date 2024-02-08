//
//  ContentView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import CloudKit
import RevenueCat
import SwiftUI

@MainActor class ShowOnboardingView: ObservableObject {
    @Published private(set) var show = true
    
    func setShow(_ value: Bool) {
        show = value
    }
}

@MainActor class BlurContentView: ObservableObject {
    @Published private(set) var blur = false
    
    func setBlur(_ value: Bool) {
        blur = value
    }
}

struct ContentView: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @EnvironmentObject private var blurContentView: BlurContentView
    @StateObject private var viewModel = ViewModel()
    
    @ObservedObject var showOnboardingView = ShowOnboardingView()
    
    @AppStorage(AppStorageKeys.currentAppearanceType) private var currentAppearanceTypeAppStorage = AppearanceTypeEnum.system
    
    // MARK: - Body
    var body: some View {
        VStack {
            if showOnboardingView.show {
                OnboardingView(showOnboardingView: showOnboardingView)
            } else {
                if signInWithAppleManager.showSighWithApple {
                    SignInView()
                } else {
                    TabView {
                        Group {
                            OwnedWishListView()
                                .tabItem {
                                    Label("My Wishes", systemImage: "sparkles.rectangle.stack")
                                }
                            
                            SharedWishListView()
                                .tabItem {
                                    Label("Shared" , systemImage: "rectangle.stack.badge.person.crop")
                                }
                            
                            SettingsView()
                                .tabItem {
                                    Label("Settings", systemImage: "gearshape")
                                }
                        }
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                    }
                    .blur(radius: blurContentView.blur ? 2.0 : 0.0)
                    .sheet(isPresented: viewModel.showPaywallSheet, content: {
                        RevenueCatPaywallView()
                    })
                    .alert(viewModel.sharedInfoAlertTitle, isPresented: viewModel.showSharedInfoAlert, actions: {
                        Button(role: .cancel) {
                        } label: {
                            Text("Ok")
                        }
                    }, message: {
                        Text(viewModel.sharedInfoAlertMessage)
                    })
                    .onAppear {
                        signInWithAppleManager.fetchUser()
                        
                        // TODO: Set this in CoreDataModel
                        viewModel.setOwnedFolder(coreDataModel, signInWithAppleManager.user)
                        viewModel.removeDuplicateFolders(coreDataModel)
                        viewModel.removeNoOnesFolders(coreDataModel)
                        
                        NotificationCenter.default.addObserver(forName: NotificationNames.shareSuccessfullyAccepted,
                                                               object: nil,
                                                               queue: .main) { _ in
                            viewModel.setSharedInfoAlertContent(.success)
                            viewModel.toggleShowSharedInfoAlert()
                        }
                        NotificationCenter.default.addObserver(forName: NotificationNames.errorDuringAcceptingShare,
                                                               object: nil,
                                                               queue: .main) { _ in
                            viewModel.setSharedInfoAlertContent(.error)
                            viewModel.toggleShowSharedInfoAlert()
                        }
                    }
                }
            }
        }
        .onAppear {
            let isFirstLaunchUserDefaults = UserDefaults.standard.value(forKey: UserDefaultsKey.isFirstLaunch) as? Bool
            
            if isFirstLaunchUserDefaults == false {
                showOnboardingView.setShow(false)
            }
            signInWithAppleManager.fetchUser()
            
            Purchases.shared.syncPurchases { customerInfo, error in
                guard customerInfo != nil else {
                    subscriptionManager.fetchSubscriptionStatus(coreDataModel)
                    return
                }
                subscriptionManager.fetchSubscriptionStatus(coreDataModel)
            }
        }
        .preferredColorScheme(currentAppearanceTypeAppStorage == AppearanceTypeEnum.light ? .light : currentAppearanceTypeAppStorage == AppearanceTypeEnum.dark ? .dark : nil)
    }
}

#Preview {
    ContentView()
}
