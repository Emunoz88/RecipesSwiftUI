//
//  CarouselContentView.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import SwiftUI

struct CarouselContentView: View {
    var recipes: [Recipe]
    @Binding var selectedIndex: Int
    private let maxVisibleDots = 5

    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(recipes.chunked(into: 2).indices, id: \.self) { index in
                    VStack(spacing: 16) {
                        ForEach(recipes.chunked(into: 2)[index], id: \.self) { recipe in
                            CarouselItem(recipe: recipe)
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                        }
                    }
                    .padding([.leading, .trailing], 10)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            DotIndicatorView(totalPages: recipes.chunked(into: 2).count, selectedIndex: $selectedIndex)
                .padding(.top, 8)
        }
    }
}
