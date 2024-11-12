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
                    // Set specific error messages for different data types
                    if dataType == .malformedData {
                        self.errorMessage = "Failed to load malformed data: Data format is incorrect."
                    } else if dataType == .emptyData {
                        self.errorMessage = "No recipes available: Data is empty."
                    } else {
                        self.errorMessage = "Failed to load recipes: \(error.localizedDescription)"
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                if response.recipes.isEmpty {
                    self?.errorMessage = "No recipes available: Data is empty."  // Set error message if recipes list is empty
                } else {
                    self?.recipes = response.recipes
                }
            })
            .store(in: &cancellables)
    }
}
