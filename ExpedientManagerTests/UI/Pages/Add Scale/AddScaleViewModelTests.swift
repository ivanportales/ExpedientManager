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
    private var saveFixedScaleUseCase: SaveStubUseCase<FixedScale>!
    private var saveOnDutyUseCase: SaveStubUseCase<OnDuty>!
    private var subscribers: Set<AnyCancellable>!

    func test_request_authorization_to_send_notifications() {
        makeSUT()
        
        viewModel.requestAuthorizationToSendNotifications()
        
        XCTAssertTrue(askForNotificationPermissionUseCase.didCallAskForNotificationPermission)
    }
    
    func test_save_fixed_scale() {
        let fixedScale = FixedScale.mockModels.first!
        makeSUT(fixedScale: fixedScale)
       
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [AddScaleViewModelState] = [
            .initial,
            .loading,
            .successSavingScale
        ]
       
        viewModel.save(fixedScale: fixedScale)
       
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
        XCTAssertEqual(saveFixedScaleUseCase.value?.title, fixedScale.title)
        XCTAssertEqual(saveFixedScaleUseCase.value?.annotation, fixedScale.annotation)
        XCTAssertEqual(saveFixedScaleUseCase.value?.initialDate, fixedScale.initialDate)
        XCTAssertEqual(saveFixedScaleUseCase.value?.finalDate, fixedScale.finalDate)
        XCTAssertEqual(saveFixedScaleUseCase.value?.colorHex, fixedScale.colorHex)
        XCTAssertEqual(saveFixedScaleUseCase.value?.scale?.type, fixedScale.scale?.type)
        XCTAssertEqual(saveFixedScaleUseCase.value?.scale?.scaleOfWork, fixedScale.scale?.scaleOfWork)
        XCTAssertEqual(saveFixedScaleUseCase.value?.scale?.scaleOfRest, fixedScale.scale?.scaleOfRest)
    }

    // MARK: - Helpers Functions

    private func makeSUT(fixedScale: FixedScale? = nil,
                         onDuty: OnDuty? = nil,
                         fixedScaleError: Error? = nil,
                         onDutyError: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.askForNotificationPermissionUseCase = AskForNotificationPermissionUseCaseStub()
        self.saveFixedScaleUseCase = SaveStubUseCase(error: fixedScaleError)
        self.saveOnDutyUseCase = SaveStubUseCase(error: onDutyError)
        self.viewModel = AddScaleViewModel(askForNotificationPermissionUseCase: askForNotificationPermissionUseCase,
                                           saveFixedScaleUseCase: saveFixedScaleUseCase,
                                           saveOnDutyUseCase: saveOnDutyUseCase)
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
