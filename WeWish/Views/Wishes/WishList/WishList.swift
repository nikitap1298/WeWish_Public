//
//  WishList.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import SwiftUI

struct WishList: View {
    
    // MARK: - Properties
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @EnvironmentObject private var coreDataModel: CoreDataModel
    @StateObject private var viewModel = ViewModel()
    
    @Binding var path: NavigationPath
    
    private var sortedWishes: [Wish] {
        let currentUserId = signInWithAppleManager.user?.uid
        
        let filteredWishes: [Wish]
        if sharedTab {
            if viewModel._selectedChartType == WishType.all.rawValue {
                filteredWishes = coreDataModel.wishes
                    .filter { $0.folder == coreDataModel.selectedOtherUserFolder }
            } else {
                filteredWishes = coreDataModel.wishes
                    .filter { $0.folder == coreDataModel.selectedOtherUserFolder && $0.buyUserId == currentUserId }
            }
        } else {
            filteredWishes = coreDataModel.wishes
                .filter { $0.folder == coreDataModel.selectedOwnedFolder }
        }
        
        let sortedWishesBySortType: [Wish]
        
        switch selectedSortType {
        case SortWishesEnum.byPrice.rawValue:
            sortedWishesBySortType = filteredWishes
                .sorted { $0.initialPrice > $1.initialPrice }
        case SortWishesEnum.byCreatedAt.rawValue:
            sortedWishesBySortType = filteredWishes
                .sorted { $0.createdAt ?? Date.now > $1.createdAt ?? Date.now }
        default:
            sortedWishesBySortType = filteredWishes
        }
        
        return sortedWishesBySortType
            .sorted { $0.isFavorite && !$1.isFavorite }
    }
    
    private var wishesToBuy: [Wish] {
        return coreDataModel.wishes.filter { $0.folder == coreDataModel.selectedOtherUserFolder && $0.buyUserId == signInWithAppleManager.user?.uid }
    }
    
    private var sharedTab: Bool
    private var selectedSortType: String?
    
    init(_ path: Binding<NavigationPath>, sharedTab: Bool, _ selectedSortType: String? = nil) {
        _path = path
        self.sharedTab = sharedTab
        self.selectedSortType = selectedSortType
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if sharedTab && !wishesToBuy.isEmpty {
                Picker("", selection: viewModel.selectedChartType) {
                    ForEach([WishType.all.rawValue, WishType.IBuy.rawValue], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
            }
            
            ScrollView {
                ForEach(sortedWishes) { wish in
                    Button(action: {
                        if sharedTab {
                            path.append(SharedNavigationRoutes.wishOverview)
                        } else {
                            path.append(OwnedNavigationRoutes.wishOverview)
                            coreDataModel.selectedWish = wish
                        }
                        coreDataModel.selectedWish = wish
                    }, label: {
                        WishRow(wish)
                            .id(wish.name)
                            .id(wish.isFavorite)
                            .id(wish.initialPrice)
                            .id(wish.image)
                    })
                    .foregroundStyle(CustomColor.blackAndWhite)
                    .padding()
                    .background(CustomColor.whiteAndSystemGray5)
                    .cornerRadius(20)
                    .padding(.bottom, 10)
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1)
                }
                .padding(.horizontal)
                .padding(.top, 7)
            }
            .onChange(of: wishesToBuy) { _, _ in
                if wishesToBuy.isEmpty {
                    viewModel.setSelectedChartType(WishType.all.rawValue)
                }
            }
        }
    }
}

//#Preview {
//    WishList()
//}
