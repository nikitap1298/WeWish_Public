//
//  OnboardingView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 14.11.23.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = ViewModel()
    @ObservedObject private var showOnboardingView: ShowOnboardingView
    
    init(showOnboardingView: ShowOnboardingView) {
        self.showOnboardingView = showOnboardingView
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "AccentColor")
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.2)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea(.all)
            VStack {
                if viewModel.isGetStarted {
                    Spacer()
                    Image(uiImage: UIImage(named: "AppIcon") ?? UIImage.actions)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 125)
                        .cornerRadius(22)
                        .padding(.bottom, 40)
                    Text("Welcome to WeWish!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    BottomActionButton({
                        Feedback().impactOccured()
                        viewModel.setIsGetStarted(false)
                    }, buttonImageName: "",
                       buttonText: "Get Started",
                       buttonColor: Color.accentColor)
                } else {
                    TabView(){
                        ForEach(viewModel.rowData, id: \.id) { data in
                            OnboardingRow(showOnboardingView: showOnboardingView,
                                          data.imageName,
                                          data.title,
                                          data.description,
                                          data.id,
                                          viewModel.rowData.count)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                }
            }
        }
    }
}

//#Preview {
//    OnboardingView()
//}
