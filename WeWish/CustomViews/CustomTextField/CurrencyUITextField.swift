//
//  CurrencyUITextField.swift
//  WeWish
//
//  Created by Nikita on 30.10.23.
//

import SwiftUI
import UIKit

class CurrencyUITextField: UITextField {
    @Binding private var value: Int
    private let formatter: NumberFormatter
    
    init(formatter: NumberFormatter, value: Binding<Int>) {
        self.formatter = formatter
        _value = value
        super.init(frame: .zero)
        text = String(value.wrappedValue)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview _: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(resetSelection), for: .allTouchEvents)
        keyboardType = .numberPad
        sendActions(for: .editingChanged)
        
        let toolbar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let image = UIImage(systemName: "keyboard.chevron.compact.down")?.withTintColor(.blackWhite, renderingMode: .alwaysOriginal)
        let hideKeyboardButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(doneButtonTapped))
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpace, hideKeyboardButton], animated: false)
        inputAccessoryView = toolbar
    }
    
    override func deleteBackward() {
        text = textValue.digits.dropLast().string
        sendActions(for: .editingChanged)
    }
    
    @objc private func doneButtonTapped() {
        resignFirstResponder()
    }
    
    @objc private func editingChanged() {
        text = currency(from: decimal)
        resetSelection()
        value = Int((round(doubleValue * 100) / 100) * 100)
    }
    
    @objc private func resetSelection() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }
    
    private var textValue: String {
        text ?? ""
    }
    
    private var doubleValue: Double {
        (decimal as NSDecimalNumber).doubleValue
    }
    
    private var decimal: Decimal {
        textValue.decimal / pow(10, formatter.maximumFractionDigits)
    }
    
    private func currency(from decimal: Decimal) -> String {
        formatter.string(for: decimal) ?? ""
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter(\.isWholeNumber) }
}

extension String {
    var decimal: Decimal { Decimal(string: digits) ?? 0 }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

