//
//  ScaleColorSelectionViewTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 06/05/24.
//

import XCTest
@testable import ExpedientManager

class ScaleColorSelectionViewTests: XCTestCase {
    var sut: ScaleColorSelectionView!

    func test_initialState() {
        makeSUT()
        
        XCTAssertEqual(sut.selectedColor, sut.colors.first!)
        XCTAssertEqual(sut.numberOfItems(inSection: 0), sut.colors.count)
    }

    private func makeSUT() {
        sut = ScaleColorSelectionView()
    }
}
