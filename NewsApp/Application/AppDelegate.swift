//
//  AppDelegate.swift
//  intro-lab-novexex
//
//  Created by Artour Ilyasov on 04.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = MainViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
