//
//  SceneDelegate.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/15/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        if AuthManager.shared.isSignedIn {
            // signed in UI
            window.rootViewController = TabBarViewController()
        }
        else {
            // sign in ui
            let vc = LoginViewController()
            let navVC = UINavigationController(rootViewController: vc)
            window.rootViewController = navVC
        }

        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

