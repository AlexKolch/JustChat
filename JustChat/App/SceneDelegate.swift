//
//  SceneDelegate.swift
//  JustChat
//
//  Created by Алексей Колыченков on 09.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var userDefaults = UserDefaults.standard

    private func startApp() {
        let startTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController")
        window?.rootViewController = startTabBarController
        window?.makeKeyAndVisible()
    }
    
    private func startLogin() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        userDefaults.set(false, forKey: "isAuth")
        let isAuth = userDefaults.object(forKey: "isAuth") as? Bool ?? false //флаг авторизации юзера в приложении
        
        //Механизм проверки авторизации
        if isAuth {
            startApp()
        } else {
            startLogin()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

