//
//  AppDelegate.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/15/23.
//

import Firebase
import UIKit
import Appirater

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Appirater.appLaunched(true)
        Appirater.setAppId("3182731283")
        Appirater.setDebug(false)
        Appirater.setDaysUntilPrompt(3)

        FirebaseApp.configure()

        // Add dummy notification for current user
//        let id = NotificationsManager.newIdentifier()
//        let model = IGNotification(
//            identifer: id,
//            notificationType: 3,
//            profilePictureUrl: "https://iosacademy.io/assets/images/brand/icon.jpg",
//            username: "joebiden",
//            dateString: String.date(from: Date()) ?? "Now",
//            isFollowing: false,
//            postId: nil,
//            postUrl: nil
//        )
//        NotificationsManager.shared.create(notification: model, for: "iosacademy")

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Appirater.appEnteredForeground(true)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

