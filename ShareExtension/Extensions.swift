//
//  Extensions.swift
//  ShareExtension
//
//  Created by Nikita Pishchugin on 10.12.23.
//

import Foundation

// MARK: - String
extension String {
    func extractURLString() -> String? {
        let pattern = #"https://[^\s)]+"#

        // Create a regular expression object
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        // Find the URL match in the string
        if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            
            guard let urlRange = Range(match.range, in: self) else { return nil }
            let url = String(self[urlRange])
            return url
        } else {
            return nil
        }
    }
}
