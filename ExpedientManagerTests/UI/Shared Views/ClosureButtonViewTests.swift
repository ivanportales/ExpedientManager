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
    
    func test_touchDownCompletion_parameter_injected_calledWhenButtonPressed() {
        var previousCompletionCalled = false
        var newCompletionCalled = false

        makeSUT(touchDownCompletion: { _ in previousCompletionCalled = true })
        
        button.touchDownCompletion = { _ in newCompletionCalled = true }
        button.sendActions(for: .touchDown)
        
        XCTAssertFalse(previousCompletionCalled)
        XCTAssertTrue(newCompletionCalled)
    }
    
    func test_buttonTitle_init_injected() {
        let buttonTitle = "Button Title"

        makeSUT(buttonTitle: buttonTitle)
            
        XCTAssertEqual(button.titleLabel?.text, buttonTitle)
    }
    
    func test_changeText_updatesButtonTitle() {
        makeSUT()
        let newText = "New Text"
      
        button.change(text: newText)
      
        XCTAssertEqual(button.titleLabel?.text, newText)
    }
    
    func makeSUT(buttonTitle: String = "Test",
                 touchDownCompletion: ((ClosureButtonView) -> Void)? = nil) {
        button = ClosureButtonView(title: buttonTitle, touchDownCompletion: touchDownCompletion)
    }
}
