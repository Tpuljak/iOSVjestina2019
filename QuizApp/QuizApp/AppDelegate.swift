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
        
        
        var viewController: UIViewController
        
        if UserDefaults.standard.valueExists(forKey: "token") {
            viewController = QuizTableViewController()
        } else {
            viewController = LoginViewController()
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

