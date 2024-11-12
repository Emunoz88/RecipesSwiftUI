//
//  ImageCacheable.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import UIKit

protocol ImageCacheable {
    func cacheImage(_ image: UIImage, for url: URL)
    func getCachedImage(for url: URL) -> UIImage?
}
