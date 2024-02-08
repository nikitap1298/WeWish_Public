//
//  Extensions.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import UIKit
import SwiftUI

// MARK: - UIImage
extension UIImage {
    func reduceHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

// MARK: - View
extension View {
    
    // Custom view border
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

// MARK: - NavigationPath
extension NavigationPath{
    mutating func popToRoot() {
        self = NavigationPath()
    }
}

// MARK: - String
extension String {
    func extractDomain() -> String? {
        guard let url = URL(string: self),
              let host = url.host else {
            return nil
        }
        
        let components = host.components(separatedBy: ".")
        if components.count >= 2 {
            return components.suffix(2).joined(separator: ".")
        } else {
            return nil
        }
    }
    
    func extractNumber() -> Int {
        let index = self.replacingOccurrences(of: " ", with: "!").firstIndex(of: "!")
        var cleanedString = ""
        
        // Remove non-numeric characters and convert commas to dots
        if let index {
            cleanedString = self[..<index]
                .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        } else {
            cleanedString = self
                .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        }
        
        if let number = Int(cleanedString) {
            return number
        } else {
            return 0
        }
    }
}

// MARK: - CGFloat
extension CGFloat {
    func getAppIconCornerRadious() -> CGFloat {
        return 10 / 57 * self
    }
}

// UIApplication
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
