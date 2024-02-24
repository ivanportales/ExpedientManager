//
//  UIBarButtonItem+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 24/02/24.
//

@testable import ExpedientManager
import UIKit

extension UIBarButtonItem {
    func testTap() {
        if let closureButton = customView as? ClosureButtonView {
            closureButton.touchDownCompletion?(closureButton)
        }
    }
}
