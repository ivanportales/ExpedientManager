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
    
    func test_textRect_isInsetByPadding() {
        makeSUT()
        let bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        let expectedRect = bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
       
        XCTAssertEqual(textField.textRect(forBounds: bounds), expectedRect)
    }
    
    func test_placeholderRect_isInsetByPadding() {
        makeSUT()
        let bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        let expectedRect = bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
      
        XCTAssertEqual(textField.placeholderRect(forBounds: bounds), expectedRect)
    }
        
    func makeSUT() {
        textField = TextField(placeholder: "Placeholder", textColor: .black)
    }
}
