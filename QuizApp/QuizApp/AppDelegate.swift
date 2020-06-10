//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Toma Puljak on 07/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        
        if UserDefaults.standard.valueExists(forKey: "token") {
            let quizTableItem = UITabBarItem()
            quizTableItem.title = "Quizzes"
            quizTableItem.image = UIImage(systemName: "list.dash")
            
            let quizTableViewController = QuizTableViewController()
            
            let settingsItem = UITabBarItem()
            settingsItem.title = "Settings"
            settingsItem.image = UIImage(systemName: "gear")
            
            let settingsViewController = SettingsViewController()
            settingsViewController.tabBarItem = settingsItem
            
            let searchItem = UITabBarItem()
            searchItem.title = "Search"
            searchItem.image = UIImage(systemName: "magnifyingglass")
            
            let searchViewController = SearchViewController()
            searchViewController.tabBarItem = searchItem
            
            let quizTableNavigationController = UINavigationController(rootViewController: quizTableViewController)
            quizTableNavigationController.tabBarItem = quizTableItem
            
            let rootViewController = UITabBarController()
            rootViewController.viewControllers = [quizTableNavigationController, settingsViewController, searchViewController]
            
            window?.rootViewController = rootViewController
        } else {
            let viewController = LoginViewController()
            
            let rootViewController = UINavigationController(rootViewController: viewController)
            
            window?.rootViewController = rootViewController
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

