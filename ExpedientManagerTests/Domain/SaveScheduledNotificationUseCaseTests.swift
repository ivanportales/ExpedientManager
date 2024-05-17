//
//  SaveScheduledNotificationUseCaseTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 16/05/24.
//

import XCTest
@testable import ExpedientManager

class SaveScheduledNotificationUseCaseTests: XCTestCase {
    var sut: SaveScheduledNotificationUseCase!
    var mockScheduledNotificationsRepository: ScheduledNotificationRepositoryStub!
    var mockNotificationManager: UserNotificationsManagerStub!

    func test_saveScheduledNotification_success() {
        makeSUT()
        
        let scheduledNotification = ScheduledNotification.getModels().first!
        let expectation = self.expectation(description: "SaveScheduledNotificationUseCase saves scheduled notification successfully")

        sut.save(scheduledNotification: scheduledNotification) { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
            case .failure(let error):
                XCTFail("SaveScheduledNotificationUseCase failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func makeSUT(repositoryError: Error? = nil,
                 managerError: Error? = nil) {
        mockScheduledNotificationsRepository = ScheduledNotificationRepositoryStub(error: repositoryError)
        mockNotificationManager = UserNotificationsManagerStub(error: managerError)
        sut = SaveScheduledNotificationUseCase(
            scheduledNotificationsRepository: mockScheduledNotificationsRepository,
            notificationManager: mockNotificationManager)
    }
}
