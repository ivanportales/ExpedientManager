//
//  ScaleSelectTypeTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 26/04/24.
//

import XCTest
@testable import ExpedientManager

class ScaleSelectTypeTests: XCTestCase {
    var sut: ScaleSelectType!
    var delegate: MockScaleSelectTypeDelegate!

    func test_initialState() {
        makeSUT()
        
        XCTAssertEqual(sut.selectedWorkScale, .fixedScale)
        XCTAssertEqual(sut.workDuration, 24)
        XCTAssertEqual(sut.restDuration, 48)
    }

    func test_onDutyHidesRestLineStackContainer() {
        makeSUT()
        
        sut.selectedWorkScale = .onDuty

        XCTAssertTrue(sut.restLineStackContainer.isHidden)
    }

    func test_fixedScaleShowsRestLineStackContainer() {
        makeSUT()
        
        sut.selectedWorkScale = .fixedScale

        XCTAssertFalse(sut.restLineStackContainer.isHidden)
    }
    
    func test_workDurationValueChanged() {
        makeSUT()
        
        sut.workDurantionTxtField.text = "5"

        XCTAssertEqual(sut.workDuration, 5)
    }
    
    func makeSUT() {
        sut = ScaleSelectType()
        delegate = MockScaleSelectTypeDelegate()
        sut.delegate = delegate
    }
}

class MockScaleSelectTypeDelegate: ScaleSelectTypeDelegate {
    var workDuration: Int?
    var restDuration: Int?
    var workScaleType: WorkScaleType?

    func workDurarionValueChanged(_ view: ScaleSelectType, workDuration: Int, restDuration: Int) {
        self.workDuration = workDuration
        self.restDuration = restDuration
    }

    func workScaleTypeChanged(_ view: ScaleSelectType, scaleType: WorkScaleType) {
        self.workScaleType = scaleType
    }
}
