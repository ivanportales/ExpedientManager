//
//  OnboardingViewControllerTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 12/03/24.
//

@testable import ExpedientManager
import Foundation
import XCTest

class OnboardingViewControllerTests: XCTestCase {
    
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

extension OnboardingViewController {
    func currentDisplayedMessage() -> String {
        let index = carouselView.currentShowedItemIndex
        return carouselView.models[index].message
    }
}
