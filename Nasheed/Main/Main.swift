//
//  Main.swift
//  Nasheed
//
//  Created by Dzakhon on 18/02/25.
//

import UIKit
import SwiftUI
import SwiftData

final class Main {
    
    private var mainWindow: UIWindow?

    func createWindow() {
        do {
            let container = try ModelContainer(for: NasheedEntity.self) // ✅ Initialize SwiftData
            
            let contentView = MainView()
                .modelContainer(container) // ✅ Attach the SwiftData container properly
            
            mainWindow = UIWindow()
            mainWindow?.rootViewController = UIHostingController(rootView: contentView) // ✅ Use the correct view
            mainWindow?.makeKeyAndVisible()
            
        } catch {
            fatalError("❌ Failed to initialize SwiftData: \(error)")
        }
    }
}

