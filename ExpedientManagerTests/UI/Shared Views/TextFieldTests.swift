import XCTest
@testable import ExpedientManager

final class TextFieldTests: XCTestCase {
    
    private var textField: TextField!
    
    func test_placeholder_isSetWhenTextFieldIsCreated() {
        makeSUT()
        XCTAssertEqual(textField.placeholder, "Placeholder")
    }

    func makeSUT() {
        textField = TextField(placeholder: "Placeholder", textColor: .black)
    }
}
