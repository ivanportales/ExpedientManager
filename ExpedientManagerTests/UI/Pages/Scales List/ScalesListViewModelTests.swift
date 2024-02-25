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
    var subscribers: Set<AnyCancellable>!

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

    // MARK: - Helpers Functions

    private func makeSUT(fixedScales: [FixedScale] = [],
                         onDuties: [OnDuty] = [],
                         fixedScalesError: Error? = nil,
                         onDutiesError: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = ScalesListViewModel(getFixedScalesUseCase: GetStubUseCase(values: fixedScales, error: fixedScalesError),
                                             getOnDutyUseCase:  GetStubUseCase(values: onDuties, error: onDutiesError))
    }
    
    private func listenToStateChange(_ callback: @escaping (ScalesListViewModelState) -> Void) {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { state in
                callback(state)
            }
            .store(in: &subscribers)
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
