//
//  RecipeViewModelTests.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//
import XCTest
import Combine
@testable import RecipesSwiftUI

class RecipeViewModelTests: XCTestCase {
    var viewModel: RecipeViewModel!
    var mockSession: MockURLSession!
    var cancellables: Set<AnyCancellable>!
    var mockImageCache: MockImageCache!

    override func setUp() {
        super.setUp()
        cancellables = []
        mockSession = MockURLSession()
        mockImageCache = MockImageCache()
        viewModel = RecipeViewModel(imageCache: mockImageCache)
    }

    override func tearDown() {
        cancellables = []
        super.tearDown()
    }

    func testFetchRecipes_HappyPath() {
        let mockData = """
        {
            "recipes": [
                { "name": "Recipe 1", "photoURLLarge": "https://example.com/photo1.jpg" },
                { "name": "Recipe 2", "photoURLLarge": "https://example.com/photo2.jpg" }
            ]
        }
        """.data(using: .utf8)

        let mockResponse = HTTPURLResponse(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)

        mockSession = MockURLSession(mockData: mockData, mockResponse: mockResponse, mockError: nil)
        viewModel.fetchRecipes(dataType: .allRecipes)

        viewModel.$recipes
            .dropFirst()  // Ignore the initial empty state
            .sink { recipes in
                XCTAssertEqual(recipes.count, 2)
                XCTAssertEqual(recipes.first?.name, "Recipe 1")
                XCTAssertEqual(recipes.last?.name, "Recipe 2")
            }
            .store(in: &cancellables)
    }

    func testFetchRecipes_SadPath() {
        let mockData: Data? = nil
        let mockResponse = HTTPURLResponse(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)

        mockSession = MockURLSession(mockData: mockData, mockResponse: mockResponse, mockError: nil)
        viewModel.fetchRecipes(dataType: .allRecipes)

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                XCTAssertTrue(errorMessage!.contains("Failed to load recipes"))
            }
            .store(in: &cancellables)
    }

    func testCacheImage_StoreAndRetrieve_HappyPath() {
        let mockImage = UIImage(systemName: "star")!
        let recipe = Recipe(id: "1", cuisine: "Any", name: "star", photoURLLarge: URL(string: "https://example.com/photo1.jpg")!, photoURLSmall: URL(string: "https://example.com/photo1.jpg")!, sourceURL: nil, youtubeURL: nil, cachedImage: nil)
        
        mockImageCache.cacheImage(mockImage, for: recipe.photoURLLarge)
        
        let cachedImage = mockImageCache.getCachedImage(for: recipe.photoURLLarge)
        XCTAssertEqual(cachedImage, mockImage)
    }

    func testCacheImage_RetrieveNonExistentImage_SadPath() {
        let cachedImage = mockImageCache.getCachedImage(for: URL(string: "https://example.com/nonexistent.jpg")!)
        XCTAssertNil(cachedImage)
    }
}
