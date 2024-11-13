//
//  CarouselItem.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/11/24.
//

import SwiftUI

struct CarouselItem: View {
    var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let cachedImage = recipe.cachedImage {
                Image(uiImage: cachedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                AsyncImage(url: recipe.photoURLLarge) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } placeholder: {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text(recipe.cuisine)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding([.leading, .trailing, .bottom], 10)
        }
    }
}
