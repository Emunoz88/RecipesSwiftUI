//
//  DotIndicatorView.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import SwiftUI

struct DotIndicatorView: View {
    var totalPages: Int
    @Binding var selectedIndex: Int
    private let maxVisibleDots = 5

    var body: some View {
        HStack(spacing: 8) {
            ForEach(getVisibleDotIndices(), id: \.self) { index in
                Circle()
                    .fill(selectedIndex == index ? Color.white : Color.gray.opacity(0.5))
                    .frame(width: selectedIndex == index ? 12 : 8, height: selectedIndex == index ? 12 : 8)
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
        }
    }
    
    func getVisibleDotIndices() -> [Int] {
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
