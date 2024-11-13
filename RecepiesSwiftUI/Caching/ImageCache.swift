//
//  ImageCache.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import UIKit

class ImageCache: ImageCacheable {
    private let cache = NSCache<NSURL, UIImage>()

    func cacheImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }

    func getCachedImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
}
