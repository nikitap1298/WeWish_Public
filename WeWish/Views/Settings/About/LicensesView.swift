//
//  LicensesView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 05.12.23.
//

import SwiftUI

struct LicensesView: View {
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea(.all)
            List {
                Section {
                    ForEach(LicensesRowData.data, id: \.self) { data in
                        NavigationLink {
                            if data.id == 0 {
                                GroupBoxView(GroupBoxModel(id: data.id,
                                                           labelText: "License",
                                                           mainText: Agreements.scrollViewSectionKit,
                                                           navigationTitle: data.title))
                            } else if data.id == 1 {
                                GroupBoxView(GroupBoxModel(id: data.id,
                                                           labelText: "License",
                                                           mainText: Agreements.spIndicator,
                                                           navigationTitle: data.title))
                            } else if data.id == 2 {
                                GroupBoxView(GroupBoxModel(id: data.id,
                                                           labelText: "License",
                                                           mainText: Agreements.swiftSoup,
                                                           navigationTitle: data.title))
                            } else if data.id == 3 {
                                GroupBoxView(GroupBoxModel(id: data.id,
                                                           labelText: "License",
                                                           mainText: Agreements.uiDeviceComplete,
                                                           navigationTitle: data.title))
                            }
                        } label: {
                            AboutViewRow(data)
                        }
                    }
                    .listRowBackground(CustomColor.whiteAndSystemGray5)
                    .frame(height: 25)
                } footer: {
                    HStack {
                        Spacer()
                        Text("Thanks to all those amazing people 💚")
                        Spacer()
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .environment(\.defaultMinListRowHeight, 10)
            .iPadPadding(.eight)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Licenses")
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    LicensesView()
}
