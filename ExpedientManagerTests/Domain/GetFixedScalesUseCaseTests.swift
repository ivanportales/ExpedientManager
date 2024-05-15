//
//  GetFixedScalesUseCaseTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 15/05/24.
//

import XCTest
@testable import ExpedientManager

class GetFixedScalesUseCaseTests: XCTestCase {
    var sut: GetFixedScalesUseCase!
    var mockFixedScaleRepository: FixedScaleRepositoryStub!

    func test_getFixedScales_success() {
        let fixedScales = FixedScale.mockModels
        makeSUT(fixedScales: fixedScales)
        let expectation = self.expectation(description: "GetFixedScalesUseCase gets fixed scales successfully")

        sut.getFixedScales { result in
            switch result {
            case .success(let models):
                XCTAssertEqual(models, fixedScales)
            case .failure(let error):
                XCTFail("GetFixedScalesUseCase failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_getFixedScales_failure() {
        let fixedScalesError = NSError(domain: "Error Message", code: 0)
        makeSUT(error: fixedScalesError)
        
        let expectation = self.expectation(description: "GetFixedScalesUseCase fails to get fixed scales")

        sut.getFixedScales { result in
            switch result {
            case .success(let fixedScales):
                XCTFail("GetFixedScalesUseCase succeeded unexpectedly")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, fixedScalesError.localizedDescription)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func makeSUT(error: Error? = nil,
                 fixedScales: [FixedScale] = [])  {
        mockFixedScaleRepository = FixedScaleRepositoryStub(error: error,
                                                            fixedScales: fixedScales)
        sut = GetFixedScalesUseCase(fixedScaleRepository: mockFixedScaleRepository)
    }
}
