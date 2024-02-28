//
//  ScalesListViewModelTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 24/02/24.
//

import Combine
@testable import ExpedientManager
import XCTest

final class ScalesListViewModelTests: XCTestCase {
    
    private var viewModel: ScalesListViewModel!
    private let currentDateForTesting: Date = Date.customDate()!
    private var subscribers: Set<AnyCancellable>!

    func testGetAllScales() {
        let fixedScales = FixedScale.mockModels
        let onDuties = OnDuty.mockModels
        let expectedScheduledNotifications = fixedScales.map { $0.toScheduledNotification() }
        makeSUT(fixedScales: fixedScales, onDuties: onDuties)
        
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [ScalesListViewModelState] = [
            .initial,
            .loading,
            .content(scheduledNotifications: expectedScheduledNotifications, selectedWorkScale: .fixedScale)
        ]
        
        viewModel.getAllScales()
        
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }
    
    func testGetAllScalesWithErrorOnFixedScales() {
        let expectedError = NSError(domain: "Error", code: 0)
        makeSUT(fixedScalesError: expectedError)
        
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [ScalesListViewModelState] = [
            .initial,
            .loading,
            .error(message: expectedError.localizedDescription)
        ]
        
        viewModel.getAllScales()
        
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }
    
    func testGetAllScalesWithErrorOnOnDuties() {
        let expectedError = NSError(domain: "Error", code: 0)
        makeSUT(onDutiesError: expectedError)
        
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [ScalesListViewModelState] = [
            .initial,
            .loading,
            .error(message: expectedError.localizedDescription)
        ]
        
        viewModel.getAllScales()
        
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }
    
    func testChangeSelectedWorkScale() {
        let fixedScales = FixedScale.mockModels
        let onDuties = OnDuty.mockModels
        let fixedScalesScheduledNotifications = fixedScales.map { $0.toScheduledNotification() }
        let onDutiesScheduledNotifications = onDuties.map { $0.toScheduledNotification() }

        makeSUT(fixedScales: fixedScales, onDuties: onDuties)
        
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [ScalesListViewModelState] = [
            .initial,
            .loading,
            .content(scheduledNotifications: fixedScalesScheduledNotifications, selectedWorkScale: .fixedScale),
            .content(scheduledNotifications: onDutiesScheduledNotifications, selectedWorkScale: .onDuty),
            .content(scheduledNotifications: fixedScalesScheduledNotifications, selectedWorkScale: .fixedScale),
        ]
        
        viewModel.getAllScales()
        viewModel.change(selectedWorkScale: .onDuty)
        viewModel.change(selectedWorkScale: .fixedScale)

        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }

    // MARK: - Helpers Functions

    private func makeSUT(fixedScales: [FixedScale] = [],
                         onDuties: [OnDuty] = [],
                         fixedScalesError: Error? = nil,
                         onDutiesError: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = ScalesListViewModel(getFixedScalesUseCase: GetStubUseCase(values: fixedScales, error: fixedScalesError),
                                             getOnDutyUseCase:  GetStubUseCase(values: onDuties, error: onDutiesError))
    }
}

extension GetStubUseCase<FixedScale>: GetFixedScalesUseCaseProtocol {
    func getFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ()) {
        get(completion: completionHandler)
    }
}

extension GetStubUseCase<OnDuty>: GetOnDutyUseCaseProtocol {
    func getOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ()) {
        get(completion: completionHandler)
    }
}
