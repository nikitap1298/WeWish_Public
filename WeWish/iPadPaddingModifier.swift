//
//  iPadPaddingModifier.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 07.12.23.
//

import SwiftUI

protocol iPhonePaddingValueProtocol {
    var rawValue: CGFloat? { get }
}

enum iPhonePaddingValueEnum: iPhonePaddingValueProtocol {
    /*
     nil - if it is a BottomButton
     0 - if it is a Section of the Form
     8 - if it is a Section of the List
     */
    case noValue
    case zero
    case eight

    var rawValue: CGFloat? {
        switch self {
        case .noValue:
            return nil
        case .zero:
            return 0
        case .eight:
            return 8
        }
    }
}

struct iPadPaddingModifier: ViewModifier {
    var iPhonePadding: CGFloat?
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : iPhonePadding)
    }
}

extension View {
    func iPadPadding(_ iPhonePadding: iPhonePaddingValueEnum) -> some View {
        modifier(iPadPaddingModifier(iPhonePadding: iPhonePadding.rawValue))
    }
}
