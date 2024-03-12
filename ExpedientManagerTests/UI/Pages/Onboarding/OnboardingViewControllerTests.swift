//
//  OnboardingViewControllerTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 12/03/24.
//

@testable import ExpedientManager
import Foundation
import XCTest

final class OnboardingViewControllerTests: XCTestCase {
    
    var viewController: OnboardingViewController!
    var router: DeeplinkRouterStub!
    var setValueForKeyUseCase: SetValueForKeyUseCaseStub!
    
    func test_initialState() {
        makeSUT()
        
        XCTAssertEqual(viewController.currentDisplayedMessage(), LocalizedString.onboardingMsg1)
        XCTAssertFalse(router.didCallPop)
        XCTAssertNil(setValueForKeyUseCase.lastSavedKey)
        XCTAssertNil(setValueForKeyUseCase.lastSavedValue)
    }
    
    func test_tapOnContinueButton_changesDisplayedMessage() {
        makeSUT()
         
        viewController.advanceButton.testTap()
        XCTAssertEqual(viewController.currentDisplayedMessage(), LocalizedString.onboardingMsg2)
         
        viewController.advanceButton.testTap()
        XCTAssertEqual(viewController.currentDisplayedMessage(), LocalizedString.onboardingMsg3)
    }
    
    func test_tapOnContinueButton_afterLastMessage_callsPopAndSave() {
        makeSUT()
        
        viewController.advanceButton.testTap()
        viewController.advanceButton.testTap()
        viewController.advanceButton.testTap()
        
        XCTAssertTrue(router.didCallPop)
        XCTAssertEqual(setValueForKeyUseCase.lastSavedKey, .hasOnboarded)
        XCTAssertEqual((setValueForKeyUseCase.lastSavedValue as? Bool), true)
    }
     
    // MARK: - Helpers Functions

    private func makeSUT() {
        self.router = DeeplinkRouterStub()
        self.setValueForKeyUseCase = SetValueForKeyUseCaseStub()
        self.viewController = OnboardingViewController(router: router!,
                                                       setValueForKeyUseCase: setValueForKeyUseCase)
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
    }
}

// MARK: - Helper Extensions

extension OnboardingViewController {
    
    // MARK: - View Helpers
    
    func currentDisplayedMessage() -> String {
        let index = carouselView.currentShowedItemIndex
        return carouselView.models[index].message
    }
}
