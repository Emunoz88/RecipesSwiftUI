//
//  CarouselItem.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/11/24.
//

import SwiftUI

struct CarouselItem: View {
    var recipe: (image: String, name: String, category: String)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background image with rounded corners
            Image(recipe.image)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    // Bottom overlay with title and category
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recipe.name)
                            .font(.system(size: 24, weight: .bold, design: .rounded)) // Fun, bold font for recipe name
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text(recipe.category)
                            .font(.system(size: 18, weight: .medium, design: .rounded)) // Fun font for recipe category
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding([.leading, .trailing, .bottom], 10),
                    alignment: .bottom
                )
        }
    }
}
