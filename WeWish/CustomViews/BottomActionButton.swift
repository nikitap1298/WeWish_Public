//
//  BottomActionButton.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 08.11.23.
//

import SwiftUI

struct BottomActionButton: View {
    
    // MARK: - Properties
    private var action: () -> Void
    private var buttonImageName: String
    private var buttonText: String
    private var buttonColor: Color
    
    init(_ action: @escaping () -> Void,
         buttonImageName: String,
         buttonText: String,
         buttonColor: Color) {
        self.action = action
        self.buttonImageName = buttonImageName
        self.buttonText = buttonText
        self.buttonColor = buttonColor
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Button(action: {
                action()
            }, label: {
                HStack {
                    Image(systemName: buttonImageName)
                    Text(buttonText)
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity ,maxHeight: 45)
            })
            .foregroundStyle(Color(uiColor: .systemGray6))
            .background(buttonColor)
            .cornerRadius(10)
            .padding(.bottom, 5)
            .iPadPadding(.noValue)
//            .shadow(color: .black.opacity(0.6), radius: 15, x: 1, y: 1)
        }
    }
}
