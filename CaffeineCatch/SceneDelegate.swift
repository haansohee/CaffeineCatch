//
//  SceneDelegate.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = SplashViewController()
    }
}

extension SceneDelegate {
    func changeRootViewController(_ rootViewController: UIViewController, animated: Bool) {
        self.window?.rootViewController = rootViewController
        UIView.transition(with: self.window!, duration: 0.2, options: [.transitionCrossDissolve], animations: nil)
    }
}
