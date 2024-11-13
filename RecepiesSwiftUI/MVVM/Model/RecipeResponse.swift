//
//  RecipeResponse.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/11/24.
//


import SwiftUI
import Combine

// Models
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable, Hashable {
    let id: String
    let cuisine: String
    let name: String
    let photoURLLarge: URL
    let photoURLSmall: URL
    let sourceURL: URL?
    let youtubeURL: URL?
    var cachedImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
