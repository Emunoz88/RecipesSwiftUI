//
//  CarouselHeaderView.swift
//  RecipesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import SwiftUI

struct CarouselHeaderView: View {
    @Binding var showActionSheet: Bool
    var viewModel: RecipeViewModel

    var body: some View {
        HStack {
            Text("Recipes")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding([.leading, .top], 24)
            
            Spacer()
            
            Button(action: {
                showActionSheet = true
            }) {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.green.opacity(0.6))
                    .frame(width: 40, height: 40)
            }
            .padding([.top, .trailing], 24)
            .actionSheet(isPresented: $showActionSheet) {
                getActionSheet()
            }
        }
    }
    
    private func getActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("Select Data Type"),
            message: Text("Choose which data type to load"),
            buttons: [
                .default(Text("All Recipes")) { viewModel.fetchRecipes(dataType: .allRecipes) },
                .default(Text("Malformed Data")) { viewModel.fetchRecipes(dataType: .malformedData) },
                .default(Text("Empty Data")) { viewModel.fetchRecipes(dataType: .emptyData) },
                .cancel()
            ]
        )
    }
}
