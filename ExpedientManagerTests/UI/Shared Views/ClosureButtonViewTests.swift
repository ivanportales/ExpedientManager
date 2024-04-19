//
//  ClosureButtonViewTest.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 18/04/24.
//

import XCTest
@testable import ExpedientManager

final class ClosureButtonViewTests: XCTestCase {
    
    private var button: ClosureButtonView!
    
    func test_touchDownCompletion_init_injected_calledWhenButtonPressed() {
        var completionCalled = false
        makeSUT(touchDownCompletion: { _ in completionCalled = true })
        
        button.sendActions(for: .touchDown)
        
        XCTAssertTrue(completionCalled)
    }
    
    func makeSUT(buttonTitle: String = "Test",
                 touchDownCompletion: ((ClosureButtonView) -> Void)? = nil) {
        button = ClosureButtonView(title: buttonTitle, touchDownCompletion: touchDownCompletion)
    }
}
