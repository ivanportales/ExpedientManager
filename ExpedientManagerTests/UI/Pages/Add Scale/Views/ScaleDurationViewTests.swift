//
//  ScaleDurationViewTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 22/04/24.
//

import XCTest
@testable import ExpedientManager

final class ScaleDurationViewTests: XCTestCase {
    
    private var scaleDurationView: ScaleDurationView!
    private var mockDelegate: MockScaleDurationViewDelegate!
    
    func test_dateAndTime_areSetWhenViewIsCreated() {
        makeSUT()
        
        let date = Date()
        XCTAssertEqual(scaleDurationView.date.formateDate(), date.formateDate())
        XCTAssertEqual(scaleDurationView.date.formatTime(), date.formatTime())
    }
    
    func test_dateTextField_isEditableWhenIsEditableIsTrue() {
        makeSUT()
        
        scaleDurationView.set(isEditable: true)
        
        XCTAssertTrue(scaleDurationView.dateTextField.isEnabled)
    }
    
    func makeSUT() {
        mockDelegate = MockScaleDurationViewDelegate()
        scaleDurationView = ScaleDurationView(durationType: .startingTime, isEditable: true, initialTime: Date())
        scaleDurationView.delegate = mockDelegate
    }
}

final class MockScaleDurationViewDelegate: ScaleDurationViewDelegate {
    var dateChangedCalled = false
    var hourChangedCalled = false
    
    func dateChangedTo(date: Date) {
        dateChangedCalled = true
    }
    
    func hourChangedTo(date: Date) {
        hourChangedCalled = true
    }
}
