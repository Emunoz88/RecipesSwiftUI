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
        errorMessage = nil
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
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
    
    private func cacheImages(for recipes: [Recipe]) {
        for index in recipes.indices {
            var recipe = recipes[index]
            
            let imageURL = recipe.photoURLLarge
            
            if let cachedImage = getCachedImage(for: imageURL) {
                recipe.cachedImage = cachedImage
                self.recipes[index] = recipe
            } else {
                downloadImage(from: imageURL) { image in
                    if let image = image {
                        self.cacheImage(image, for: imageURL)
                        recipe.cachedImage = image
                        self.recipes[index] = recipe
                    }
                }
            }
        }
    }

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
    
    private func cacheImage(_ image: UIImage, for url: URL) {
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

    private func getCachedImage(for url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
