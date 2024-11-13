//
//  MockImageCache.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import UIKit

class MockImageCache: ImageCacheable {
    private var cache = [URL: UIImage]()

    func cacheImage(_ image: UIImage, for url: URL) {
        cache[url] = image
    }

    func getCachedImage(for url: URL) -> UIImage? {
        return cache[url]
    }
}
