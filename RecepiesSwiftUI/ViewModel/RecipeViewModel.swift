//
//  RecipeViewModel.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/11/24.
//

import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    // Enum to represent different data endpoints
    enum DataType {
        case allRecipes
        case malformedData
        case emptyData
        
        var urlString: String {
            switch self {
            case .allRecipes:
                return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
            case .malformedData:
                return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
            case .emptyData:
                return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
            }
        }
    }

    func fetchRecipes(dataType: DataType) {
        guard let url = URL(string: dataType.urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil  // Clear any previous errors
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                // Check for valid HTTP response
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to load recipes: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                if response.recipes.isEmpty {
                    self?.errorMessage = "No recipes available: Data is empty."
                } else {
                    self?.recipes = response.recipes
                    self?.cacheImages(for: response.recipes)
                }
            })
            .store(in: &cancellables)
    }
    
    // Cache images to disk
    private func cacheImages(for recipes: [Recipe]) {
        for index in recipes.indices {
            var recipe = recipes[index]  // Make the recipe mutable
            
            // Ensure recipe has a valid photoURL
            let imageURL = recipe.photoURLLarge
            
            // Check if the image is cached
            if let cachedImage = getCachedImage(for: imageURL) {
                // Update the recipe's cachedImage property with the cached image
                recipe.cachedImage = cachedImage
                // Replace the updated recipe in the recipes array
                self.recipes[index] = recipe
            } else {
                // If not cached, download and cache
                downloadImage(from: imageURL) { image in
                    if let image = image {
                        // Cache the image
                        self.cacheImage(image, for: imageURL)
                        // Update the recipe with the new image and replace in the array
                        recipe.cachedImage = image
                        self.recipes[index] = recipe
                    }
                }
            }
        }
    }

    
    // Download image from URL
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    // Store image in cache
    private func cacheImage(_ image: UIImage, for url: URL) {
        guard let imageData = image.pngData() else { return }

        // Create a dummy URLResponse
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

    
    // Retrieve cached image
    private func getCachedImage(for url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
