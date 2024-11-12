//
//  ImageCache.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import UIKit

class ImageCache: ImageCacheable {
    func cacheImage(_ image: UIImage, for url: URL) {
        guard let imageData = image.pngData() else { return }

        let response = URLResponse(
            url: url,
            mimeType: "image/png",
            expectedContentLength: imageData.count,
            textEncodingName: nil
        )

        let cachedResponse = CachedURLResponse(
            response: response,
            data: imageData
        )
        
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
    }

    func getCachedImage(for url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
