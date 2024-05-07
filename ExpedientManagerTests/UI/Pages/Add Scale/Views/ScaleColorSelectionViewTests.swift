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
    
    func test_setupWithSelectedColor() {
        makeSUT()
        
        let selectedColor = UIColor.selectionRed
        sut.setup(selectedColor: selectedColor)

        XCTAssertEqual(sut.selectedColor, selectedColor)
    }
    
    func test_selectColor() {
        makeSUT()
      
        let indexPath = IndexPath(item: 0, section: 0)
        sut.collectionView(sut, didSelectItemAt: indexPath)

        XCTAssertEqual(sut.selectedColor, sut.colors[indexPath.item])
    }
    
    func test_cellForItemAt() {
        makeSUT()
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.collectionView(sut, cellForItemAt: indexPath) as? ScaleColorSelectionCellView

        XCTAssertEqual(cell!.colorView.backgroundColor, sut.colors[indexPath.item])
    }
    
    func test_numberOfItemsInSection() {
        makeSUT()
        
        let numberOfItems = sut.collectionView(sut, numberOfItemsInSection: 0)

        XCTAssertEqual(numberOfItems, sut.colors.count)
    }

    private func makeSUT() {
        sut = ScaleColorSelectionView()
    }
}
