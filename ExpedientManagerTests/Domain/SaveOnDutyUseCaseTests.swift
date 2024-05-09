//
//  SaveOnDutyUseCaseTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 08/05/24.
//

import XCTest
@testable import ExpedientManager

class SaveOnDutyUseCaseTests: XCTestCase {
    var sut: SaveOnDutyUseCase!
    var mockOnDutyRepository: MockOnDutyRepository!
    var mockSaveScheduledNotificationUseCase: MockSaveScheduledNotificationUseCase!

    func test_saveOnDuty_success() {
        makeSUT()
        
        let onDuty = OnDuty.mockModels.first!
        let expectation = self.expectation(description: "SaveOnDutyUseCase saves on duty successfully")

        sut.save(onDuty: onDuty) { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
            case .failure(let error):
                XCTFail("SaveOnDutyUseCase failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_saveOnDuty_failure() {
        let onDutyError = NSError(domain: "Error Message", code: 0)

        makeSUT(onDutyRepositoryError: onDutyError)
        let onDuty = OnDuty.mockModels.first!
        let expectation = self.expectation(description: "SaveOnDutyUseCase fails to save on duty")


        sut.save(onDuty: onDuty) { result in
            switch result {
            case .success(let success):
                XCTFail("SaveOnDutyUseCase succeeded unexpectedly")
            case .failure(let error):
                XCTAssertEqual(onDutyError.localizedDescription, error.localizedDescription)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func makeSUT(onDutyRepositoryError: Error? = nil,
                 saveNotificationUseCaseError: Error? = nil) {
        mockOnDutyRepository = MockOnDutyRepository(error: onDutyRepositoryError)
        mockSaveScheduledNotificationUseCase = MockSaveScheduledNotificationUseCase(error: saveNotificationUseCaseError)
        sut = SaveOnDutyUseCase(onDutyRepository: mockOnDutyRepository,
                                saveScheduledNotificationUseCase: mockSaveScheduledNotificationUseCase)
    }
}

// MARK: - Helper Classes

class MockOnDutyRepository: OnDutyRepositoryProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(true))
        }
    }

    func getAllOnDuty(completionHandler: @escaping (Result<[ExpedientManager.OnDuty], any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func delete(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func update(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
}

class MockSaveScheduledNotificationUseCase: SaveScheduledNotificationUseCaseProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func save(scheduledNotification: ScheduledNotification, completion: @escaping (Result<Bool, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(true))
        }
    }
}
