import XCTest
@testable import ExpedientManager

final class TextFieldTests: XCTestCase {
    
    private var textField: TextField!
    
    func test_placeholder_isSetWhenTextFieldIsCreated() {
        makeSUT()
        XCTAssertEqual(textField.placeholder, "Placeholder")
    }
    
    func test_textColor_isSetWhenTextFieldIsCreated() {
        makeSUT()
        XCTAssertEqual(textField.textColor, .black)
    }
        
    func makeSUT() {
        textField = TextField(placeholder: "Placeholder", textColor: .black)
    }
}
