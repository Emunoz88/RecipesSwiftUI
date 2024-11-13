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
        // Set up the image cache and a sample URL for testing
        imageCache = ImageCache()
        url = URL(string: "https://example.com/image.png")!
        image = UIImage(named: "Pasta") ?? UIImage()
    }

    override func tearDown() {
        // Clear URLCache to avoid affecting other tests
        URLCache.shared.removeAllCachedResponses()
        super.tearDown()
    }

    // Test caching of an image
    func testCacheImage() {
        // Call the cacheImage method
        imageCache.cacheImage(image, for: url)
        
        // Retrieve the cached image
        if let cachedImage = imageCache.getCachedImage(for: url) {
            XCTAssertNotNil(cachedImage)
            
            // Convert both images to PNG data and compare them
            let cachedImageData = cachedImage.pngData()
            let originalImageData = image.pngData()
            
            // Assert that the PNG data is the same for both images
            XCTAssertEqual(cachedImageData, originalImageData, "The cached image data should match the original image data.")
        } else {
            XCTFail("Failed to retrieve cached image")
        }
    }

    
    // Test caching when no image is present
    func testGetCachedImageWhenNoImage() {
        // Try to get a cached image that doesn't exist
        let cachedImage = imageCache.getCachedImage(for: url)
        
        // Assert that the cached image is nil since no image was cached
        XCTAssertNil(cachedImage, "There should be no cached image for this URL")
    }


    // Test caching invalid data
    func testCacheImageWithInvalidData() {
        // Call the cacheImage method with invalid image (empty UIImage)
        let invalidImage = UIImage()
        imageCache.cacheImage(invalidImage, for: url)
        
        // Try to retrieve it
        let cachedImage = imageCache.getCachedImage(for: url)
        
        // Check that the cached image is nil, as invalid images cannot be cached properly
        XCTAssertNil(cachedImage)
    }
    
    // Test if cache is cleared
    func testCacheClearing() {
        // First, cache an image
        imageCache.cacheImage(image, for: url)
        
        // Now, clear the cache and try to retrieve the image again
        URLCache.shared.removeAllCachedResponses()
        
        // Try to get the cached image after clearing the cache
        let cachedImage = imageCache.getCachedImage(for: url)
        
        XCTAssertNil(cachedImage, "The cached image should be nil after clearing the cache")
    }
}
