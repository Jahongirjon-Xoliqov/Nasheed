//
//  Main.swift
//  Nasheed
//
//  Created by Dzakhon on 18/02/25.
//

import UIKit
import SwiftUI

final class Main {
    
    private var mainWindow: UIWindow?
    
    func createWindow() {
        mainWindow = UIWindow()
        mainWindow?.rootViewController = UIHostingController(rootView: MainView())
        mainWindow?.makeKeyAndVisible()
    }
    
}
