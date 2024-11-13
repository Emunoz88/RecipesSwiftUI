//
//  ImageCacheTests.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//
import XCTest
import UIKit
@testable import RecepiesSwiftUI

class ImageCacheTests: XCTestCase {
    
    var imageCache: ImageCache!
    var url: URL!
    var image: UIImage!
    
    override func setUp() {
        super.setUp()
        imageCache = ImageCache()
        url = URL(string: "https://example.com/image.png")!
        image = UIImage(systemName: "star") ?? UIImage()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCacheImage() {
        imageCache.cacheImage(image, for: url)
        
        let cachedImage = imageCache.getCachedImage(for: url)
        
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage?.pngData(), image.pngData(), "The cached image data should match the original image data.")
    }

    func testGetCachedImageWhenNoImage() {
        let cachedImage = imageCache.getCachedImage(for: url)
    
        XCTAssertNil(cachedImage, "There should be no cached image for this URL")
    }
}
