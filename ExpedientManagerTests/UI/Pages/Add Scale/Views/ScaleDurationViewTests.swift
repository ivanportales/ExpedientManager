//
//  ScaleDurationViewTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 22/04/24.
//

@testable import ExpedientManager
import XCTest

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
    
    func test_dateTextField_isNotEditableWhenIsEditableIsFalse() {
        makeSUT()
        
        scaleDurationView.set(isEditable: false)
        
        XCTAssertFalse(scaleDurationView.dateTextField.isEnabled)
    }
    
    func test_dateAndTime_areUpdatedWhenDatePickerDoneTapped() {
        makeSUT()
        let newDate = Date().addingTimeInterval(60 * 60 * 24)
        scaleDurationView.datePicker.date = newDate
        scaleDurationView.datePickerDoneTapped()
        
        XCTAssertEqual(scaleDurationView.date.formateDate(), newDate.formateDate())
        XCTAssertTrue(mockDelegate.dateChangedCalled)
    }
    
    func test_dateAndTime_areUpdatedWhenTimePickerDoneTapped() {
        makeSUT()

        let newTime = Date().addingTimeInterval(60 * 60)
        scaleDurationView.timePicker.date = newTime
        scaleDurationView.timePickerDoneTapped()
        
        XCTAssertEqual(scaleDurationView.date.formatTime(), newTime.formatTime())
        XCTAssertTrue(mockDelegate.hourChangedCalled)
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
    var changedDate: Date?
    
    func dateChangedTo(date: Date) {
        dateChangedCalled = true
        changedDate = date
    }
    
    func hourChangedTo(date: Date) {
        hourChangedCalled = true
        changedDate = date
    }
}
