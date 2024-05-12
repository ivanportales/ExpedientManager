//
//  GetScheduledNotificationsUseCaseTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 11/05/24.
//

import XCTest
@testable import ExpedientManager

class GetScheduledNotificationsUseCaseTests: XCTestCase {
    var sut: GetScheduledNotificationsUseCase!
    var mockScheduledNotificationRepository: ScheduledNotificationRepositoryStub!

    func test_getScheduledNotifications_success() {
        let modelsMock = ScheduledNotification.getModels()
        makeSUT(scheduledNotifications: modelsMock)
        let expectation = self.expectation(description: "GetScheduledNotificationsUseCase gets on duty successfully")

        sut.getScheduledNotifications { result in
            switch result {
            case .success(let scheduledNotifications):
                XCTAssertEqual(scheduledNotifications, modelsMock)
            case .failure(let error):
                XCTFail("GetScheduledNotificationsUseCase failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func makeSUT(error: Error? = nil,
                 scheduledNotifications: [ScheduledNotification] = []) {
        mockScheduledNotificationRepository = ScheduledNotificationRepositoryStub(error: error, scheduledNotifications: scheduledNotifications)
        sut = GetScheduledNotificationsUseCase(scheduledNotificationsRepository: mockScheduledNotificationRepository)
    }
}
