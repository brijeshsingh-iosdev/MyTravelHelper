//
//  AppDelegate.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let notice = SearchTrainRouter.createModule()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = notice
        self.window = window
        window.makeKeyAndVisible()
        return false
    }
}

