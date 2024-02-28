//
//  LoadingShowableViewControllerProtocol+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 27/02/24.
//

@testable import ExpedientManager
import Foundation

extension LoadingShowableViewControllerProtocol {
    func isLoadingViewDisplayed() -> Bool {
        return loadingView != nil
    }
}
