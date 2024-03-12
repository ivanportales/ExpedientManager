//
//  ButtonView+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 12/03/24.
//

@testable import ExpedientManager

extension ButtonView {
    func testTap() {
        touchDownCompletion?(self)
    }
}
