//
//  DotIndicatorViewTests.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//

import XCTest
@testable import RecepiesSwiftUI

final class DotIndicatorViewTests: XCTestCase {
    func testVisibleDotIndicesWhenTotalPagesLessThanMax() {
        let dotIndicatorView = DotIndicatorView(totalPages: 4, selectedIndex: .constant(1))
        let indices = dotIndicatorView.getVisibleDotIndices()
        
        XCTAssertEqual(indices, [0, 1, 2, 3], "Expected all indices visible when total pages < max visible dots")
    }
    
    func testVisibleDotIndicesWhenTotalPagesGreaterThanMax() {
        let dotIndicatorView = DotIndicatorView(totalPages: 10, selectedIndex: .constant(5))
        let indices = dotIndicatorView.getVisibleDotIndices()
        
        XCTAssertEqual(indices, [3, 4, 5, 6, 7], "Expected a middle subset of indices for selected index in the middle")
    }
    
    func testVisibleDotIndicesWhenSelectedIndexAtStart() {
        let dotIndicatorView = DotIndicatorView(totalPages: 10, selectedIndex: .constant(1))
        let indices = dotIndicatorView.getVisibleDotIndices()
        
        XCTAssertEqual(indices, [0, 1, 2, 3, 4], "Expected start indices visible when selected index is near start")
    }
    
    func testVisibleDotIndicesWhenSelectedIndexAtEnd() {
        let dotIndicatorView = DotIndicatorView(totalPages: 10, selectedIndex: .constant(9))
        let indices = dotIndicatorView.getVisibleDotIndices()
        
        XCTAssertEqual(indices, [5, 6, 7, 8, 9], "Expected end indices visible when selected index is near end")
    }
}
