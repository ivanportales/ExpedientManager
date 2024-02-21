//
//  HomeViewModelTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 20/02/24.
//

import Combine
@testable import ExpedientManager
import XCTest

final class HomeViewModelTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private let currentDateForTesting: Date = Date.customDate()!
    var subscribers: Set<AnyCancellable>!

    func testFetchScheduledNotificationsWithOneNotificationScheduledForDate() {
        let models = ScheduledNotification.getModels()
        makeSUT(scheduledNotifications: models, dateOfFilter: currentDateForTesting)
        
        let stateSpy = ViewModelPublisherSpy<HomeViewModelState>(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [HomeViewModelState] = [
            .initial,
            .loading,
            .content(notificationsCount: 10, filteredNotifications: [models[0]])
        ]
        
        viewModel.fetchScheduledNotifications()
        
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }

    // MARK: - Helpers Functions

    private func makeSUT(scheduledNotifications: [ScheduledNotification] = [],
                         dateOfFilter: Date,
                         valueToBeReturned: Bool? = false,
                         error: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = HomeViewModel(getScheduledNotificationsUseCase: GetScheduledNotificationsUseCaseStub(scheduledNotifications: scheduledNotifications, error: error),
                                       getValueForKeyUseCase: GetValueForKeyUseCaseStub(returnedValue: valueToBeReturned),
                                       dateOfFilter: dateOfFilter)
    }
}
