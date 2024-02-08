//
//  AboutView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

struct AboutView: View {
    
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            VStack {
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage.actions)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125)
                    .cornerRadius(22)
                    .padding(.vertical, 40)
                Text("WeWish")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                List {
                    ForEach(AboutRowData.data, id: \.self) { data in
                        if data.id <= 1 {
                            AboutViewRow(data)
                        } else if data.id == 2 {
                            Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                .foregroundStyle(CustomColor.blackAndWhite)
                        } else if data.id == 3 {
                            Link("Privacy Policy", destination: URL(string: "https://nikitap1298.github.io/wewishprivacypolicy.md")!)
                                .foregroundStyle(CustomColor.blackAndWhite)
                        } else {
                            NavigationLink {
                                LicensesView()
                            } label: {
                                AboutViewRow(data)
                            }
                        }
                    }
                    .listRowBackground(colorScheme == .light ? .white : Color(uiColor: .systemGray5))
                    .frame(height: 25)
                }
                .scrollContentBackground(.hidden)
                .environment(\.defaultMinListRowHeight, 10)
                .scrollDisabled(true)
                .iPadPadding(.eight)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Text in the back button becomes "Back"
            ToolbarItem(placement: .principal) {
                Text("About WeWish")
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    AboutView()
}
