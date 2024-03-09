//
//  FlowController.swift
//  DiabloCompanionApp
//
//  Created by Gonzalo Ivan Santos Portales on 21/05/23.
//

import UIKit

enum Deeplink: String {
    case onboard = "expedientManager://onboard"
    case home = "expedientManager://home"
    case addScale = "expedientManager://add_scale"
    case scaleList = "expedientManager://scale_list"
}

protocol DeeplinkRouterProtocol {
    func route(to deeplink: Deeplink, withParams params: [String: Any])
    func pop()
}

final class DeeplinkRouter: DeeplinkRouterProtocol {
    
    // MARK: - Private Properties
    
    private let navigationController: UINavigationController
    
    // MARK: - Exposed Properties
    
    var factory: ViewControllersFactory?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.setupNavigationBar()
    }
    
    // MARK: - Exposed Functions
    
    func route(to deeplink: Deeplink, withParams params: [String: Any] = [:]) {
        switch deeplink {
        case .onboard:
            showOnboardingScreen()
        case .home:
            showHomeScreen()
        case .addScale:
            showAddScaleScreen()
        case .scaleList:
            showScalesListScreen()
        }
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    private func showOnboardingScreen() {
        guard let viewController = factory?.makeOnboardingViewController() else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showHomeScreen() {
        guard let viewController = factory?.makeHomeViewController() else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showAddScaleScreen() {
        guard let viewController = factory?.makeAddScaleViewController() else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showScalesListScreen() {
        guard let viewController = factory?.makeScalesListViewController() else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationController.navigationBar.tintColor = .appDarkBlue
        navigationController.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.poppinsSemiboldOf(size: 34),
            .foregroundColor: UIColor.card,
        ]
    }
}
