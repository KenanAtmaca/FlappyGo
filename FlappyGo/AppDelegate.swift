//
//  AppDelegate.swift
//  FlappyGo
//
//  Created by Kenan Atmaca on 31.03.2018.
//  Copyright © 2018 Kenan Atmaca. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let gameVC = GameViewController()
        window?.rootViewController = gameVC
        
        return true
    }
}

