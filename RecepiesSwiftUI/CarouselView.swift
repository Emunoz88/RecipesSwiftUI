//
//  CarouselView.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/10/24.
//

import SwiftUI

struct CarouselView: View {
    let recipes: [(image: String, name: String, category: String)] = [
        ("Pasta", "Pasta", "Italian"),
        ("Pizza", "Pizza", "Italian"),
        ("Sushi", "Sushi", "Japanese"),
        ("Burger", "Burger", "American"),
        ("Salad", "Salad", "Healthy")
    ]
    
    @State private var selectedIndex = 0
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack {
            VStack {
                // Title and refresh button at the top
                HStack {
                    // Title
                    Text("Recipes")
                        .font(.system(size: 40, weight: .bold, design: .rounded)) // Fun rounded font
                        .foregroundColor(.black)
                        .padding([.leading, .top], 24)
                    
                    Spacer()  // Pushes the button to the far right
                    
                    // Refresh Button (Green refresh image)
                    Button(action: refreshRecipes) {
                        Image(systemName: "arrow.clockwise.circle.fill") // You can use SF Symbols for the refresh icon
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.green.opacity(0.6))
                            .frame(width: 40, height: 40) // Set the size of the icon
                    }
                    .padding([.top, .trailing], 24)
                }
                
                // Carousel
                TabView(selection: $selectedIndex) {
                    ForEach(0..<recipes.count/2 + (recipes.count % 2 == 0 ? 0 : 1), id: \.self) { index in
                        VStack(spacing: 16) {
                            // Display the first item
                            if let firstRecipe = recipes[safe: index * 2] {
                                CarouselItem(recipe: firstRecipe)
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                            }
                            
                            // Display the second item if available
                            if let secondRecipe = recipes[safe: index * 2 + 1] {
                                CarouselItem(recipe: secondRecipe)
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                            }
                        }
                        .padding([.leading, .trailing], 10)
                        .tag(index) // Tag each page for selection tracking
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))  // Disable default indicator
                
                // Custom Dot Indicators
                HStack {
                    ForEach(0..<recipes.count/2 + (recipes.count % 2 == 0 ? 0 : 1), id: \.self) { index in
                        Circle()
                            .fill(selectedIndex == index ? Color.black : Color.gray)
                            .frame(width: 10, height: 10)
                            .padding(5)
                    }
                }
                
                Spacer()
            }
        }
        .background(
            Image("Background") // The background image applied here
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all) // Ensures the image fills the screen
        )
    }

    
    func refreshRecipes() {
        // Simulate refreshing the recipes
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isRefreshing = false
            // You can replace the hardcoded recipe list here with a function to actually refresh the recipes if needed
            print("Recipes refreshed!")
        }
    }
}

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

// Safe array indexing
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
