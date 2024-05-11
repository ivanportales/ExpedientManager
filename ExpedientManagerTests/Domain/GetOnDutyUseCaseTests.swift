//
//  GetOnDutyUseCaseTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 10/05/24.
//

import XCTest
@testable import ExpedientManager

class GetOnDutyUseCaseTests: XCTestCase {
    var sut: GetOnDutyUseCase!
    var mockOnDutyRepository: OnDutyRepositoryStub!

    func test_getOnDuty_success() {
        let onDutiesMock = OnDuty.mockModels
        makeSUT(onDuties: onDutiesMock)
        let expectation = self.expectation(description: "GetOnDutyUseCase gets on duty successfully")

        sut.getOnDuty { result in
            switch result {
            case .success(let onDuties):
                XCTAssertEqual(onDuties, onDutiesMock)
            case .failure(let error):
                XCTFail("GetOnDutyUseCase failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func makeSUT(error: Error? = nil,
                 onDuties: [OnDuty] = []) {
        mockOnDutyRepository = OnDutyRepositoryStub(error: error, onDuties: onDuties)
        sut = GetOnDutyUseCase(onDutyRepository: mockOnDutyRepository)
    }
}
