//
//  IncludeWishesView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 27.11.23.
//

import SwiftUI

struct IncludeWishesView: View {
    
    // MARK: - Properties
    @Environment(\.editMode) private var editMode
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var coreDataModel: CoreDataModel
    
    @Binding var selectedWishes: Set<Wish>
    
    @State private var searchWishName = ""
    
    private var sortedWishes: [Wish] {
        if searchWishName.isEmpty {
            return coreDataModel.ownedFolders
                .flatMap { $0.wishArray }
                .sorted { $0.name ?? "" < $1.name ?? "" }
        } else {
            return coreDataModel.ownedFolders
                .flatMap { $0.wishArray }
                .filter { $0.name?.contains(searchWishName) ?? false }
                .sorted { $0.name ?? "" < $1.name ?? "" }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack{
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                List(sortedWishes, id: \.self, selection: $selectedWishes) { wish in
                    Text(wish.name ?? "")
                }
                .iPadPadding(.eight)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        selectedWishes = Set()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .environment(\.editMode, .constant(.transient))
        }
        .searchable(text: $searchWishName)
    }
}

//#Preview {
//    IncludeWishesView()
//}
