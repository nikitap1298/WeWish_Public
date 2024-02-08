//
//  AppearanceView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 04.12.23.
//

import SwiftUI

struct AppearanceView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = ViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            VStack {
                HStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Image("LightMode")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(AppearanceTypeEnum.light.rawValue)
                            .fontWeight(.medium)
                        Button(action: {
                            viewModel.setCurrentAppearanceType(AppearanceTypeEnum.light)
                        }, label: {
                            Image(systemName: viewModel.currentAppearanceType == AppearanceTypeEnum.light ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                        })
                    }
                    VStack(spacing: 20) {
                        Image("DarkMode")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(AppearanceTypeEnum.dark.rawValue)
                            .fontWeight(.medium)
                        Button(action: {
                            viewModel.setCurrentAppearanceType(AppearanceTypeEnum.dark)
                        }, label: {
                            Image(systemName: viewModel.currentAppearanceType == AppearanceTypeEnum.dark ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                        })
                    }
                    VStack(spacing: 20) {
                        Image("System")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(AppearanceTypeEnum.system.rawValue)
                            .fontWeight(.medium)
                        Button(action: {
                            viewModel.setCurrentAppearanceType(AppearanceTypeEnum.system)
                        }, label: {
                            Image(systemName: viewModel.currentAppearanceType == AppearanceTypeEnum.system ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                        })
                    }
                }
                .padding(.top, 20)
                .iPadPadding(.noValue)
                Spacer()
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setCurrentAppearanceTypeFromUserDefaults()
        }
    }
}

#Preview {
    AppearanceView()
}
