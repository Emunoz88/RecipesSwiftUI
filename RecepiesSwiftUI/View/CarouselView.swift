//
//  CarouselView.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/10/24.
//

import SwiftUI

struct CarouselView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var selectedIndex = 0
    private let maxVisibleDots = 5  // Maximum dots to display
    
    var body: some View {
        ZStack {
            VStack {
                // Title and refresh button at the top
                HStack {
                    Text("Recipes")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .padding([.leading, .top], 24)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedIndex = 0  // Reset the index to 0
                        viewModel.fetchRecipes()
                    }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.green.opacity(0.6))
                            .frame(width: 40, height: 40)
                    }
                    .padding([.top, .trailing], 24)
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                        .padding(.top, 20)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                } else {
                    VStack {
                        // Carousel Content
                        TabView(selection: $selectedIndex) {
                            ForEach(viewModel.recipes.chunked(into: 2).indices, id: \.self) { index in
                                VStack(spacing: 16) {
                                    ForEach(viewModel.recipes.chunked(into: 2)[index], id: \.self) { recipe in
                                        CarouselItem(recipe: recipe)
                                            .frame(width: UIScreen.main.bounds.width * 0.9)
                                    }
                                }
                                .padding([.leading, .trailing], 10)
                                .tag(index) // Important for correct binding with selectedIndex
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                        // Limited Page Indicator
                        HStack(spacing: 8) {
                            ForEach(getVisibleDotIndices(totalPages: viewModel.recipes.chunked(into: 2).count), id: \.self) { index in
                                Circle()
                                    .fill(selectedIndex == index ? Color.black : Color.gray.opacity(0.5))
                                    .frame(width: selectedIndex == index ? 12 : 8, height: selectedIndex == index ? 12 : 8)
                                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                Spacer()
            }
        }
        .background(
            Image("Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            viewModel.fetchRecipes()
        }
    }
    
    // Function to calculate the visible dot indices for the indicator
    private func getVisibleDotIndices(totalPages: Int) -> [Int] {
        if totalPages <= maxVisibleDots {
            return Array(0..<totalPages)
        }
        
        if selectedIndex <= 2 {
            return Array(0..<maxVisibleDots)
        } else if selectedIndex >= totalPages - 3 {
            return Array((totalPages - maxVisibleDots)..<totalPages)
        } else {
            return Array((selectedIndex - 2)...(selectedIndex + 2))
        }
    }
}

// Extension to split array into chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
