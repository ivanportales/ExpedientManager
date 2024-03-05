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

    // MARK: - Helpers Functions

    private func makeSUT(fixedScale: FixedScale? = nil,
                         onDuty: OnDuty? = nil,
                         fixedScaleError: Error? = nil,
                         onDutyError: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.askForNotificationPermissionUseCase = AskForNotificationPermissionUseCaseStub()
        self.viewModel = AddScaleViewModel(askForNotificationPermissionUseCase: askForNotificationPermissionUseCase,
                                           saveFixedScaleUseCase: SaveStubUseCase(value: fixedScale, error: fixedScaleError),
                                           saveOnDutyUseCase: SaveStubUseCase(value: onDuty, error: onDutyError))
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
        save(completion: completionHandler)
    }
}

extension SaveStubUseCase<OnDuty>: SaveOnDutyUseCaseProtocol {
    func save(onDuty: ExpedientManager.OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        save(completion: completionHandler)
    }
}
