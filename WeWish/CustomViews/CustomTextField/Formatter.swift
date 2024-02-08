//
//  Formatter.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import Foundation

func formatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale.current
    return formatter
}
