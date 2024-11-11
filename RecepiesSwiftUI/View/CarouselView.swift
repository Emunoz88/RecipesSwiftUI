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
                    
                    Button(action: viewModel.fetchRecipes) {
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
                    TabView(selection: $selectedIndex) {
                        ForEach(viewModel.recipes.chunked(into: 2), id: \.self) { recipePair in
                            VStack(spacing: 16) {
                                ForEach(recipePair) { recipe in
                                    CarouselItem(recipe: recipe)
                                        .frame(width: UIScreen.main.bounds.width * 0.9)
                                }
                            }
                            .padding([.leading, .trailing], 10)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                    // Custom Dot Indicators
                    HStack {
                        ForEach(0..<viewModel.recipes.count/2 + (viewModel.recipes.count % 2 == 0 ? 0 : 1), id: \.self) { index in
                            Circle()
                                .fill(selectedIndex == index ? Color.black : Color.gray)
                                .frame(width: 10, height: 10)
                                .padding(5)
                        }
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
}

// Extension to split array into chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
