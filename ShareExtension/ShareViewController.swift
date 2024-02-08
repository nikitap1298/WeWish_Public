//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Nikita Pishchugin on 20.11.23.
//

/* Found at: 
 https://medium.com/@damisipikuda/how-to-receive-a-shared-content-in-an-ios-application-4d5964229701
 */

import UIKit
import Social
import CoreServices
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    private let typeImage = String("public.image")
    private let typeURL = String("public.url")
    private let typePlainText = String("public.plain-text")
    private let appURL = "ShareExtension://"
    private let groupName = "group.WeWishGroup"
    private let urlDefaultName = "incomingURL"
    private let imageURLBookmark = "incomingImageURLBookmark"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(typeImage) {
            handleIncomingImage(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            handleIncomingURL(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(typePlainText) {
            handleIncomingPlainText(itemProvider: itemProvider)
        } else {
            print("Error: No url or text found")
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }

    private func handleIncomingImage(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeImage, options: nil) { (item, error) in
            if let error = error { print("Image-Error: \(error.localizedDescription)") }

            if let imageURL = item as? URL {
                /* It helps to handle image permissions in the main app.
                 Can't get UIImage if I pass normal image URL to the main app.
                 */
                self.saveImageURLAsBookmark(imageURL)
            }

            self.openMainApp()
        }
    }

    private func handleIncomingURL(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { (item, error) in
            if let error = error { print("URL-Error: \(error.localizedDescription)") }

            if let url = item as? NSURL, let urlString = url.absoluteString {
                self.saveURLString(urlString)
            }

            self.openMainApp()
        }
    }
    
    private func handleIncomingPlainText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typePlainText, options: nil) { (item, error) in
            if let error = error { print("PlainText-Error: \(error.localizedDescription)") }

            let itemString = item as! String
            
            if let urlString = itemString.extractURLString() {
                self.saveURLString(urlString)
            }
            
            self.openMainApp()
        }
    }
    
    private func saveImageURLAsBookmark(_ url: URL) {
        if let bookmarkData = try? url.bookmarkData() {
            UserDefaults(suiteName: self.groupName)?.set(bookmarkData, forKey: self.imageURLBookmark)
        }
    }

    private func saveURLString(_ urlString: String) {
        UserDefaults(suiteName: self.groupName)?.set(urlString, forKey: self.urlDefaultName)
    }

    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURL) else { return }
            _ = self.openURL(url)
        })
    }

    // Courtesy: https://stackoverflow.com/a/44499222/13363449 👇🏾
    // Function must be named exactly like this so a selector can be found by the compiler!
    // Anyway - it's another selector in another instance that would be "performed" instead.
    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
