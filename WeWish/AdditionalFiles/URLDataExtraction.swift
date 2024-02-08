//
//  URLDataExtraction.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 23.12.23.
//

import Foundation
import LinkPresentation

func fetchURLMetadata(from url: URL, completion: @escaping (String?, UIImage?) -> Void) {
    let metadataProvider = LPMetadataProvider()
    
    metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
        if let error = error {
            print("Error fetching metadata: \(error.localizedDescription)")
            return
        }
        
        if let metadata = metadata {
            let title = metadata.title ?? ""
            
            if let imageProvider = metadata.imageProvider {
                imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        return
                    }
                    completion(title, image as? UIImage)
                }
            } else {
                print("No image available")
                completion(title, nil)
            }
        }
    }
}
