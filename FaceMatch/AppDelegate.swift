//
//  AppDelegate.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder {
  var window: UIWindow?
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = GameViewController.instantiate()
    window?.makeKeyAndVisible()
    return true
  }
}
