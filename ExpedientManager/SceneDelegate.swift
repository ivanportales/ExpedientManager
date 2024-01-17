//
//  SceneDelegate.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 16/01/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        var navigationController: UINavigationController!
        
        if UserDefaults.standard.hasOnboarded {
            navigationController = UINavigationController(rootViewController: HomeViewController())
        } else {
            navigationController = UINavigationController(rootViewController: OnboardingViewController())
        }
        
        let safeWindow = UIWindow(windowScene: windowScene)
        safeWindow.frame = UIScreen.main.bounds
        safeWindow.rootViewController = navigationController
        safeWindow.makeKeyAndVisible()
        
        window = safeWindow
    }
}
