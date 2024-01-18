//
//  ViewControllersFactory.swift
//  destiny2AssistentApp
//
//  Created by Gonzalo Ivan Santos Portales on 01/08/22.
//

import Foundation
import SafariServices

final class ViewControllersFactory {
    
    private let localStorage: LocalStorageRepositoryProtocol = LocalStorageRepository()
    private let router: DeeplinkRouterProtocol
    
    init(router: DeeplinkRouterProtocol) {
        self.router = router
    }
    
    func makeHomeViewController() -> HomeViewController {
        let repository = CoreDataScheduledNotificationsRepository()
        let viewModel = HomeVideModel(repository: repository,
                                      router: router,
                                      localStorage: localStorage)

        return HomeViewController(viewModel: viewModel)
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController(router: router,
                                        localStorage: localStorage)
    }
    
    func makeWebView(with url: URL) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
}
