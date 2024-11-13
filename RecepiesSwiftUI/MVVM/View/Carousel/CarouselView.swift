//
//  CarouselView.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/10/24.
//

import SwiftUI

struct CarouselView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var selectedIndex = 0
    @State private var showActionSheet = false

    var body: some View {
        ZStack {
            VStack {
                CarouselHeaderView(showActionSheet: $showActionSheet, viewModel: viewModel)

                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                        .padding(.top, 20)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                } else {
                    CarouselContentView(recipes: viewModel.recipes, selectedIndex: $selectedIndex)
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
            viewModel.fetchRecipes(dataType: .allRecipes)
        }
        .onChange(of: viewModel.recipes) { _ in
            selectedIndex = 0
        }
    }
}
