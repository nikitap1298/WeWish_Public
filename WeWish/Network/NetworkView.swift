//
//  NetworkView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 25.12.23.
//

import SwiftUI

struct NetworkView: View {
    
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var networkManager: NetworkManager
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea(.all)
                VStack {
                    Image(systemName: networkManager.isConnected ? "wifi" : "wifi.exclamationmark") 
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70)
                        .foregroundStyle(CustomColor.green)
                    VStack(spacing: 15) {
                        Text(networkManager.connectionDescription)
                            .font(.title3)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        if !networkManager.isConnected {
                            Text("WeWish needs a good internet connection only after installing the app to fully set up the data.")
                                .font(.caption)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 25)
                }
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
                .onChange(of: networkManager.isConnected) { _, _ in
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    NetworkView()
}
