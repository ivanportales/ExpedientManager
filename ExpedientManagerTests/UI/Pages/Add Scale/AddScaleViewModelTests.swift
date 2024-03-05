//
//  AddScaleViewModelTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 04/03/24.
//

import Combine
@testable import ExpedientManager
import XCTest

final class AddScaleViewModelTests: XCTestCase {
    
    private var viewModel: AddScaleViewModel!
    private var askForNotificationPermissionUseCase: AskForNotificationPermissionUseCaseStub!
    private var subscribers: Set<AnyCancellable>!

    func test_request_authorization_to_send_notifications() {
        makeSUT()
        
        viewModel.requestAuthorizationToSendNotifications()
        
        XCTAssertTrue(askForNotificationPermissionUseCase.didCallAskForNotificationPermission)
    }

    // MARK: - Helpers Functions

    private func makeSUT(fixedScale: FixedScale? = nil,
                         onDuty: OnDuty? = nil,
                         fixedScaleError: Error? = nil,
                         onDutyError: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.askForNotificationPermissionUseCase = AskForNotificationPermissionUseCaseStub()
        self.viewModel = AddScaleViewModel(askForNotificationPermissionUseCase: askForNotificationPermissionUseCase,
                                           saveFixedScaleUseCase: SaveStubUseCase(error: fixedScaleError),
                                           saveOnDutyUseCase: SaveStubUseCase(error: onDutyError))
    }
}

final class AskForNotificationPermissionUseCaseStub: AskForNotificationPermissionUseCaseProtocol {
    
    var didCallAskForNotificationPermission = false
    
    func askForNotificationPermission() {
        didCallAskForNotificationPermission = true
    }
}

extension SaveStubUseCase<FixedScale>: SaveFixedScaleUseCaseProtocol {
    func save(fixedScale: ExpedientManager.FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        save(value: fixedScale, completion: completionHandler)
    }
}

extension SaveStubUseCase<OnDuty>: SaveOnDutyUseCaseProtocol {
    func save(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        save(value: onDuty, completion: completionHandler)
    }
}
