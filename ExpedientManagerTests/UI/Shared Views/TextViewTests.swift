//
//  TextViewTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 20/04/24.
//

import XCTest
@testable import ExpedientManager

final class TextViewTests: XCTestCase {
    
    private var textView: TextView!
    
    func test_placeholder_isSetWhenTextViewIsCreated() {
        makeSUT()
        XCTAssertEqual(textView.text, "Placeholder")
        XCTAssertEqual(textView.textColor, .lightGray)
    }
    
    func test_placeholder_isRemovedWhenTextViewBeginsEditing() {
        makeSUT()
        textView.textViewDidBeginEditing(textView)
        
        XCTAssertEqual(textView.text, "")
        XCTAssertEqual(textView.textColor, .black)
    }
    
    func makeSUT() {
        textView = TextView(placeholder: "Placeholder", textColor: .black)
    }
}
