//
//  OnboardingRow.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 14.11.23.
//

import SPIndicator
import SwiftUI

struct OnboardingRow: View {
    
    // MARK: - Properties
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @EnvironmentObject private var networkManager: NetworkManager
    @ObservedObject private var showOnboardingView: ShowOnboardingView
    @StateObject private var viewModel = ViewModel()
    
    private var imageName: String
    private var title: String
    private var description: String
    private var index: Int
    private var rowDataCount: Int

    init(showOnboardingView: ShowOnboardingView, _ imageName: String, _ title: String, _ description: String, _ index: Int, _ rowDataCount: Int) {
        self.showOnboardingView = showOnboardingView
        self.imageName = imageName
        self.title = title
        self.description = description
        self.index = index
        self.rowDataCount = rowDataCount
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                Spacer()
                Image(uiImage: UIImage(named: imageName) ?? .checkmark)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 350, maxHeight: 350)
                    .padding(.bottom, 50)
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding()
                Text(description)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                
                Spacer()
                if rowDataCount - 1 == index {
                    // ProgressView needed for the CoreData to boot up
                    if viewModel.showProgressView  {
                        ProgressView()
                            .frame(maxWidth: .infinity ,maxHeight: 45)
                            .tint(Color(uiColor: .systemGray6))
                            .background(.accent)
                            .cornerRadius(10)
                            .padding(.bottom, 45)
                            .iPadPadding(.noValue)
                    } else {
                        BottomActionButton({
                            Feedback().impactOccured()
                            if signInWithAppleManager.user != nil && networkManager.isConnected {
                                viewModel.toggleShowProgressView()
                                viewModel.setShowLaunchingIndicator(true)
                                Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
                                    UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.isFirstLaunch)
                                    showOnboardingView.setShow(false)
                                }
                            } else if !networkManager.isConnected {
                                viewModel.setShowNetworkViewSheet(true)
                            } else if signInWithAppleManager.user == nil {
                                UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.isFirstLaunch)
                                showOnboardingView.setShow(false)
                            }
                        }, buttonImageName: "",
                           buttonText: "Continue",
                           buttonColor: .accentColor)
                        .padding(.bottom, 40)
                    }
                } else {
                    BottomActionButton({
                    }, buttonImageName: "",
                       buttonText: "",
                       buttonColor: .clear)
                    .disabled(true)
                    .padding(.bottom, 40)
                }
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .sheet(isPresented: viewModel.showNetworkViewSheet, content: {
            NetworkView()
        })
        .onChange(of: networkManager.isConnected) { _, _ in
            if !networkManager.isConnected {
                viewModel.setShowNetworkViewSheet(true)
            } else {
                viewModel.setShowNetworkViewSheet(false)
            }
        }
        .SPIndicator(
            isPresent: viewModel.showLaunchingIndicator,
            title: "WeWish is launching, please wait 💚",
            preset: .custom(UIImage(systemName: "gearshape.2") ?? .checkmark))
    }
}

//#Preview {
//    OnboardingRow("Folder",
//                  "Your best Wishlist app",
//                  "Create, manage and share your wishes",
//                  0,
//                  0)
//}
