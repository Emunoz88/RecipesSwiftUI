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
        image = UIImage(named: "Pasta") ?? UIImage()
    }

    override func tearDown() {
        URLCache.shared.removeAllCachedResponses()
        super.tearDown()
    }


    func testCacheImage() {
        imageCache.cacheImage(image, for: url)

        if let cachedImage = imageCache.getCachedImage(for: url) {
            XCTAssertNotNil(cachedImage)
            
            let cachedImageData = cachedImage.pngData()
            let originalImageData = image.pngData()
            
            XCTAssertEqual(cachedImageData, originalImageData, "The cached image data should match the original image data.")
        } else {
            XCTFail("Failed to retrieve cached image")
        }
    }

    func testGetCachedImageWhenNoImage() {
        let cachedImage = imageCache.getCachedImage(for: url)
    
        XCTAssertNil(cachedImage, "There should be no cached image for this URL")
    }


    func testCacheImageWithInvalidData() {
        let invalidImage = UIImage()
        imageCache.cacheImage(invalidImage, for: url)
        
        let cachedImage = imageCache.getCachedImage(for: url)
        
        XCTAssertNil(cachedImage)
    }

    func testCacheClearing() {

        imageCache.cacheImage(image, for: url)
        
        URLCache.shared.removeAllCachedResponses()
        
        let cachedImage = imageCache.getCachedImage(for: url)
        
        XCTAssertNil(cachedImage, "The cached image should be nil after clearing the cache")
    }
}
