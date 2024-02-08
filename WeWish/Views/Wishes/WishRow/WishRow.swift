//
//  WishRow.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import SwiftUI

struct WishRow: View {
    
    // MARK: - Properties
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager
    @EnvironmentObject private var coreDataModel: CoreDataModel
    
    @StateObject private var viewModel = ViewModel()
    
    private var wish: Wish
    
    init(_ wish: Wish) {
        self.wish = wish
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            displayImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                }
                .padding(0)
                .frame(maxWidth: UIScreen.main.bounds.width / 4.2, maxHeight: UIScreen.main.bounds.width / 4.2)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(wish.name ?? "")
                            .font(.headline)
//                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if wish.isFavorite {
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.yellow)
                                .frame(maxHeight: 15)
                        }
                    }
                    
                    Spacer()
                    HStack {
                        if !viewModel.isOwner && wish.buyUserId != nil && wish.buyUserId != signInWithAppleManager.user?.uid {
                            Text("Another user will buy this item.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text(wish.initialPrice, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }
                }
                .padding(.leading, 8)
            }
            .padding([.top, .bottom, .trailing])
        }
        .frame(minHeight: 100, maxHeight: 130)
        .opacity(!viewModel.isOwner && wish.buyUserId != nil && wish.buyUserId != signInWithAppleManager.user?.uid ? 0.6 : 1.0)
        .onAppear {
            viewModel.setIsOwner(coreDataModel, wish)
        }
    }
    
    private func displayImage() -> Image {
        if let imageData = wish.image,
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo")
        }
    }
}

#Preview {
    WishRow(Wish())
}
