//
//  SceneDelegate.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 16/01/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var router: DeeplinkRouter?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let factory = AppMainFactory()
        window = factory.makeMainAppWindowWith(appScene: windowScene)
        router = factory.makeAppRouter()
        router?.route(to: .home)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else {
            return
        }
    }
}
