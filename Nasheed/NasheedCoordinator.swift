//
//  NasheedCoordinator.swift
//  Nasheed
//
//  Created by Dzakhon on 18/02/25.
//

import UIKit
import SwiftUI

final class NasheedCoordinator {
    private var nasheedWindow: UIWindow?
    func presentNasheedWindow() {
        nasheedWindow?.makeKeyAndVisible()
    }
    func createNasheedWindow() {
        nasheedWindow = UIWindow()
    }
    func setAsRoot(_ view: some View) {
        nasheedWindow?.rootViewController = UIHostingController(rootView: view)
    }
}
