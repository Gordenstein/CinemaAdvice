//
//  AppDelegate.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    customizeAppearance()
    FirebaseApp.configure()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {

  }

  func applicationDidEnterBackground(_ application: UIApplication) {

  }

  func applicationWillEnterForeground(_ application: UIApplication) {

  }

  func applicationDidBecomeActive(_ application: UIApplication) {

  }

  func applicationWillTerminate(_ application: UIApplication) {

  }

  // MARK: - Helper Methods
  func customizeAppearance() {
//    UINavigationBar.appearance().barTintColor = UIColor.black
//    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white ]
//    UITabBar.appearance().barTintColor = UIColor.black
  }
}
