//
//  WishToPDFView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import SwiftUI
import ScrollViewSectionKit

struct WishToPDFView: View {
    
    // MARK: - Properties
    @EnvironmentObject private var coreDataModel: CoreDataModel
    
    private var wish: Wish
    
    init(_ wish: Wish) {
        self.wish = wish
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if let wishImage = wish.image,
               let image = UIImage(data: wishImage) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(UIDevice.current.userInterfaceIdiom == .pad ? 10 : 0)
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width - 200 : UIScreen.main.bounds.width)
            }
            
            Group {
                HStack {
                    Text(wish.name ?? "")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    Text(wish.initialPrice, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.gray)
                    Spacer()
                }
                
                HStack {
                    if let wishURL = wish.url {
                        HStack {
                            Image(systemName: "link")
                            Link(wishURL.extractDomain() ?? wishURL, destination: URL(string: wishURL)!)
                                .lineLimit(1)
                                .font(.system(size: 15))
                                .foregroundStyle(CustomColor.blackAndWhite)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 25)
            }
            .iPadPadding(.noValue)
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

#Preview {
    WishToPDFView(Wish())
}
