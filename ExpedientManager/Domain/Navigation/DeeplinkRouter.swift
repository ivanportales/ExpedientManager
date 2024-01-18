//
//  FlowController.swift
//  DiabloCompanionApp
//
//  Created by Gonzalo Ivan Santos Portales on 21/05/23.
//

import UIKit

enum Deeplink: String {
    case home = "expedientManager://home"
    case onboard = "expedientManager://onboard"
}

protocol DeeplinkRouterProtocol: class {
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
        case .home:
            showHomeScreen()
        case .onboard:
            showOnboardingScreen()
        }
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    private func showHomeScreen() {
        guard let viewController = factory?.makeHomeViewController() else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showOnboardingScreen() {
        guard let viewController = factory?.makeOnboardingViewController() else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
        
    func handle(openURLContext: UIOpenURLContext) {
//        authService.handleURLFromDeepLink(openURLContext.url) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let token):
//                    self?.pop()
//                    self?.showHomeScreen(token: token)
//                case .failure(let error):
//                    self?.showErrorScreen(with: error)
//                }
//            }
//        }
    }
    
    private func setupNavigationBar() {
        navigationController.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.poppinsSemiboldOf(size: 34)
        ]
    }
}
