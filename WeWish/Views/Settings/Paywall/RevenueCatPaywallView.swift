//
//  RevenueCatPaywallView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 25.11.23.
//

// Found at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-in-app-purchases-in-swiftui

import RevenueCat
import RevenueCatUI
import SwiftUI

struct RevenueCatPaywallView: View {
    
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @StateObject private var viewModel = ViewModel()
    
    private let model = Model()
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "White&Black")
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(named: "White&Black")?.withAlphaComponent(0.2)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Image(uiImage: UIImage(named: "AppIcon") ?? UIImage.actions)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75)
                        .cornerRadius(13.1)
                    Text("WeWish Pro")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(CustomColor.whiteAndBlack)
                        .padding([.top, .horizontal], 15)
                    TabView(){
                        ForEach(model.rowData, id: \.id) { data in
                            VStack {
                                Text(data.title)
                                    .font(.body)
                                    .foregroundStyle(CustomColor.whiteAndBlack)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .frame(height: 50)
                                Image(uiImage: UIImage(named: data.imageName) ?? .checkmark)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 350, maxHeight: 350)
                                    .padding(.bottom, 50)
                            }
                            .frame(width: UIScreen.main.bounds.width)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    .frame(height: 400)
                }
                .offset(y: viewModel.isMoveScrollView ? -70 : 0)
                .animation(.easeInOut(duration: 3), value: viewModel.isMoveScrollView)
            }
            .scrollIndicatorsFlash(onAppear: true)
            .background(CustomColor.green.gradient)
            .paywallFooter(purchaseCompleted: { _ in
                presentationMode.wrappedValue.dismiss()
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .tint(CustomColor.whiteAndBlack)
                            .font(.title2)
                    })
                }
            }
            .toolbarBackground(.hidden)
            .onAppear {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    viewModel.toggleIsMoveScrollView()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                        viewModel.toggleIsMoveScrollView()
                    }
                }
            }
            .onDisappear {
                subscriptionManager.fetchSubscriptionStatus()
            }
        }
    }
}

#Preview {
    RevenueCatPaywallView()
}
