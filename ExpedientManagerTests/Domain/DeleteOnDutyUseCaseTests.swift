//
//  DeleteOnDutyUseCaseTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 20/05/24.
//

import XCTest
@testable import ExpedientManager

class DeleteOnDutyUseCaseTests: XCTestCase {
    var sut: DeleteOnDutyUseCase!
    var mockOnDutyRepository: OnDutyRepositoryStub!
    
    func test_deleteOnDuty_success() {
        makeSUT()
        let onDuty = OnDuty.mockModels.first!
        let expectation = self.expectation(description: "DeleteOnDutyUseCase deletes on duty successfully")
        
        sut.delete(onDuty: onDuty) { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
            case .failure(_):
                XCTFail("DeleteOnDutyUseCase failed unexpectedly")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_deleteOnDuty_failure() {
        let error = NSError(domain: "TestError", code: 0, userInfo: nil)
        makeSUT(error: error)
        let onDuty = OnDuty.mockModels.first!

        let expectation = self.expectation(description: "DeleteOnDutyUseCase fails to delete on duty")
        
        sut.delete(onDuty: onDuty) { result in
            switch result {
            case .success(_):
                XCTFail("DeleteOnDutyUseCase succeeded unexpectedly")
            case .failure(let receivedError):
                XCTAssertEqual(receivedError.localizedDescription, error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func makeSUT(error: Error? = nil) {
        mockOnDutyRepository = OnDutyRepositoryStub(error: error)
        sut = DeleteOnDutyUseCase(onDutyRepository: mockOnDutyRepository)
    }
}
