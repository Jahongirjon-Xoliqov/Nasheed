//
//  AppDelegate.swift
//  Nasheed
//
//  Created by Dzakhon on 18/02/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var main = Main()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        main.createWindow()
        return true
    }

    
}

