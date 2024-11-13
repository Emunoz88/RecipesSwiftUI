//
//  CarouselContentViewTests.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import XCTest
@testable import RecipesSwiftUI

final class CarouselContentViewTests: XCTestCase {
    func testChunkRecipesIntoGroupsOfTwo() {
        let recipes = [
            Recipe(id: "1", cuisine: "Italian", name: "Pasta", photoURLLarge: URL(string: "https://example.com/image1")!, photoURLSmall: URL(string: "https://example.com/image1s")!, sourceURL: nil, youtubeURL: nil, cachedImage: nil),
            Recipe(id: "2", cuisine: "Mexican", name: "Taco", photoURLLarge: URL(string: "https://example.com/image2")!, photoURLSmall: URL(string: "https://example.com/image2s")!, sourceURL: nil, youtubeURL: nil, cachedImage: nil),
            Recipe(id: "3", cuisine: "American", name: "Burger", photoURLLarge: URL(string: "https://example.com/image3")!, photoURLSmall: URL(string: "https://example.com/image3s")!, sourceURL: nil, youtubeURL: nil, cachedImage: nil)
        ]
        
        let chunked = recipes.chunked(into: 2)
        
        XCTAssertEqual(chunked.count, 2, "Expected 2 chunks")
        XCTAssertEqual(chunked[0].count, 2, "Expected 2 items in first chunk")
        XCTAssertEqual(chunked[1].count, 1, "Expected 1 item in second chunk")
    }
}
