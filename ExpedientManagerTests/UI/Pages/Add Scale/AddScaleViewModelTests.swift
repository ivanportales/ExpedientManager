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
    
    func test_save_fixed_scale_with_error() {
         let fixedScale = FixedScale.mockModels.first!
         let fixedScaleError = NSError(domain: "Error Message", code: 0)
         makeSUT(fixedScaleError: fixedScaleError)
        
         let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
         let expectedPublishedStates: [AddScaleViewModelState] = [
             .initial,
             .loading,
             .errorSavingScale(message: fixedScaleError.localizedDescription)
         ]
        
         viewModel.save(fixedScale: fixedScale)
        
         XCTAssertEqual(stateSpy.values, expectedPublishedStates)
    }
    
    func test_save_on_duty() {
        let onDuty = OnDuty.mockModels.first!
        makeSUT(onDuty: onDuty)
       
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
        let expectedPublishedStates: [AddScaleViewModelState] = [
            .initial,
            .loading,
            .successSavingScale
        ]
       
        viewModel.save(onDuty: onDuty)
       
        XCTAssertEqual(stateSpy.values, expectedPublishedStates)
        XCTAssertEqual(saveOnDutyUseCase.value?.titlo, onDuty.titlo)
        XCTAssertEqual(saveOnDutyUseCase.value?.annotation, onDuty.annotation)
        XCTAssertEqual(saveOnDutyUseCase.value?.initialDate, onDuty.initialDate)
        XCTAssertEqual(saveOnDutyUseCase.value?.hoursDuration, onDuty.hoursDuration)
        XCTAssertEqual(saveOnDutyUseCase.value?.colorHex, onDuty.colorHex)
    }
    
    func test_save_on_duty_with_error() {
        let onDuty = OnDuty.mockModels.first!
        let onDutyError = NSError(domain: "Error Message", code: 0)
        makeSUT(onDutyError: onDutyError)
        
        let stateSpy = ViewModelPublisherSpy(publisher: viewModel.$statePublished)
         let expectedPublishedStates: [AddScaleViewModelState] = [
             .initial,
             .loading,
             .errorSavingScale(message: onDutyError.localizedDescription)
         ]
        
         viewModel.save(onDuty: onDuty)
        
         XCTAssertEqual(stateSpy.values, expectedPublishedStates)
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

// MARK: - Helper Classes

fileprivate class AskForNotificationPermissionUseCaseStub: AskForNotificationPermissionUseCaseProtocol {
    
    var didCallAskForNotificationPermission = false
    
    func askForNotificationPermission() {
        didCallAskForNotificationPermission = true
    }
}

// MARK: - Protocol Adoptance Extensions

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
