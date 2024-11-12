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
            selectedIndex = 0  // Reset index to 0 when recipes update
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
