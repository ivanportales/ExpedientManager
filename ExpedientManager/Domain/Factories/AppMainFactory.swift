//
//  AppMainFactory.swift
//  destiny2AssistentApp
//
//  Created by Gonzalo Ivan Santos Portales on 01/08/22.
//

import UIKit

final class AppMainFactory {
    
    private let navigationController: UINavigationController = UINavigationController()
    
    func makeMainAppWindowWith(appScene: UIWindowScene) -> UIWindow? {
        let window = UIWindow(windowScene: appScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return window
    }
    
    func makeAppRouter() -> DeeplinkRouter {
        let router = DeeplinkRouter(navigationController: navigationController)
        let viewControllerFactory = ViewControllersFactory(router: router)
        router.factory = viewControllerFactory
        
        return router
    }
}
