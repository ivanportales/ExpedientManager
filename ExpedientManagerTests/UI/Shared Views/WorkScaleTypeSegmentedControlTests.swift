//
//  WorkScaleTypeSegmentedControlTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 19/04/24.
//

import XCTest
@testable import ExpedientManager

final class WorkScaleTypeSegmentedControlTests: XCTestCase {
    
    private var control: WorkScaleTypeSegmentedControl!
    private var delegate: MockWorkScaleTypeSegmentedControlDelegate!
    
    func test_setup_correctlySetsUpSegmentedControl() {
        makeSUT()
        let expectedTitles = WorkScaleType.allDescriptions
        
        for (index, expectedTitle) in expectedTitles.enumerated() {
            XCTAssertEqual(control.titleForSegment(at: index), expectedTitle)
        }
    }
    
    func makeSUT() {
        control = WorkScaleTypeSegmentedControl()
        delegate = MockWorkScaleTypeSegmentedControlDelegate()
        control.delegate = delegate
    }
}

final class MockWorkScaleTypeSegmentedControlDelegate: WorkScaleTypeSegmentedControlDelegate {
    var didChangeSelectedIndexCalled = false
    
    func didChangeSelectedIndex(_ view: WorkScaleTypeSegmentedControl, selectedWorkScale: WorkScaleType) {
        didChangeSelectedIndexCalled = true
    }
}
