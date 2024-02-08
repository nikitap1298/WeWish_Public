//
//  ThumbnailProtocol.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 13.11.23.
//

import SwiftSoup
import UIKit

protocol ThumbnailProtocol {
    func fetchThumbnail(from urlString: String, completion: @escaping ((String?, Int?, String?)) -> Void)
    func loadThumbnailFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void)
}

extension ThumbnailProtocol {
    func fetchThumbnail(from urlString: String, completion: @escaping ((String?, Int?, String?)) -> Void) {
        guard let url = URL(string: urlString) else {
            completion((nil, nil, nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion((nil, nil, nil))
                return
            }
            
            do {
                let html = String(data: data, encoding: .utf8)
                let doc = try SwiftSoup.parse(html ?? "")
                
                var productName: String?
                var imageURL: String?
                
                if urlString.contains("amazon") || urlString.contains("amzn") {
                    let productTitle = try doc.select("span#productTitle").first()
                    productName = try productTitle?.text()
                    
                    let productWholePrice = try doc.select("span.a-offscreen").first()
                    let wholePrice = try productWholePrice?.text().extractNumber()
                    
                    let imageElement = try doc.select("div#imgTagWrapperId img").first()
                    imageURL = try imageElement?.attr("src")
                    
                    completion((productName, wholePrice, imageURL))
                } else {
                    // Find the first image element in the HTML body
//                    let imageElement = try doc.select("img").first()?.attr("src")
//                    imageURL = "https://" + (url.host() ?? "") + (imageElement ?? "")
                    
                    completion((nil, nil, nil))
                }
            } catch {
                print("Error parsing HTML: \(error)")
                completion((nil, nil, nil))
            }
        }.resume()
    }
    
    func loadThumbnailFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let imageData = data {
                Task { @MainActor in
                    completion(UIImage(data: imageData))
                }
            }
        }.resume()
    }
}
