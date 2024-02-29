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
    private var subscribers: Set<AnyCancellable>!

    func test_fetch_scheduled_notifications_with_one_notification_scheduled_for_date() {
        let models = ScheduledNotification.getModels()
        makeSUT(scheduledNotifications: models, dateOfFilter: currentDateForTesting)
        
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [HomeViewModelState] = [
            .initial,
            .loading,
            .content(notificationsCount: 10, filteredNotifications: [models[0]])
        ]
        
        viewModel.fetchScheduledNotifications()
        
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }
    
    func test_fetch_scheduled_notifications_with_no_notification_scheduled_for_date() {
        let models = ScheduledNotification.getModels()
        makeSUT(scheduledNotifications: models, dateOfFilter: Date.customDate(month: 3)!)
       
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [HomeViewModelState] = [
            .initial,
            .loading,
            .content(notificationsCount: 10, filteredNotifications: [])
        ]
       
        viewModel.fetchScheduledNotifications()
       
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }
    
    func test_get_filtered_scheduled_dates_with_no_notification_scheduled_for_date() {
        let models = ScheduledNotification.getModels()
        makeSUT(scheduledNotifications: models, dateOfFilter: currentDateForTesting)
        
        let result = viewModel.getFilteredScheduledDatesWith(date: Date.customDate(month: 3)!)
        
        XCTAssertEqual(result, [])
    }
    
    func test_get_filtered_scheduled_dates_with_notification_scheduled_for_date() {
        let models = ScheduledNotification.getModels()
        makeSUT(scheduledNotifications: models, dateOfFilter: currentDateForTesting)
       
        viewModel.fetchScheduledNotifications()
        let result = viewModel.getFilteredScheduledDatesWith(date: currentDateForTesting)
       
        XCTAssertEqual(result, [models[0]])
   }
    
    func test_get_month_description_of_current_date() {
       let models = ScheduledNotification.getModels()
       makeSUT(scheduledNotifications: models, dateOfFilter: currentDateForTesting)
       
       viewModel.fetchScheduledNotifications()
       let result = viewModel.getMonthDescriptionOf(date: currentDateForTesting)
       
       XCTAssertEqual(result, "Janeiro")
   }
    
    func test_filter_scheduled_dates_with_current_date() {
        let models = ScheduledNotification.getModels()
        makeSUT(scheduledNotifications: models, dateOfFilter: currentDateForTesting)
        
        viewModel.fetchScheduledNotifications()
        viewModel.filterScheduledDatesWith(date: Date.customDate(day: 3)!)
        
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [HomeViewModelState] = [
            .filterContent(filteredNotifications: [models[2]])
        ]
        
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }
    
    func test_verify_first_access_on_app_to_true() {
        makeSUT(dateOfFilter: currentDateForTesting, valueToBeReturned: nil)
        var didCallRouteToOnboardingCallback = false
        
        viewModel.verifyFirstAccessOnApp(routeToOnboardingCallback: {
            didCallRouteToOnboardingCallback = true
        })
        
        XCTAssertTrue(didCallRouteToOnboardingCallback)
    }
    
    func test_verify_first_access_on_app_to_false() {
        makeSUT(dateOfFilter: currentDateForTesting, valueToBeReturned: true)
        var didCallRouteToOnboardingCallback = false
        
        viewModel.verifyFirstAccessOnApp(routeToOnboardingCallback: {
            didCallRouteToOnboardingCallback = true
        })
        
        XCTAssertFalse(didCallRouteToOnboardingCallback)
    }

    // MARK: - Helpers Functions

    private func makeSUT(scheduledNotifications: [ScheduledNotification] = [],
                         dateOfFilter: Date,
                         valueToBeReturned: Bool? = false,
                         error: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = HomeViewModel(getScheduledNotificationsUseCase: GetStubUseCase(values: scheduledNotifications, error: error),
                                       getValueForKeyUseCase: GetValueForKeyUseCaseStub(returnedValue: valueToBeReturned),
                                       dateOfFilter: dateOfFilter)
    }
}

extension GetStubUseCase<ScheduledNotification>: GetScheduledNotificationsUseCaseProtocol {
    func getScheduledNotifications(completion: @escaping (Result<[ExpedientManager.ScheduledNotification], Error>) -> Void) {
        get(completion: completion)
    }
}
