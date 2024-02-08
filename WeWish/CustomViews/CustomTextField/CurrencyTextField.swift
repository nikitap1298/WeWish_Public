//
//  CurrencyTextField.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import SwiftUI

struct CurrencyTextField: UIViewRepresentable {
    typealias UIViewType = CurrencyUITextField
    
    let numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField
    
    init(numberFormatter: NumberFormatter, value: Binding<Int>) {
        self.numberFormatter = numberFormatter
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }
    
    func makeUIView(context _: Context) -> CurrencyUITextField {
        currencyField
    }
    
    func updateUIView(_: CurrencyUITextField, context _: Context) {}
}
