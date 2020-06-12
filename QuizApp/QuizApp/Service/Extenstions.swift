//
//  Extenstions.swift
//  QuizApp
//
//  Created by Toma Puljak on 09/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit
import Foundation

protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.autoresizesSubviews = true
                    }
                }
            }
        }
    }
}

extension Array
{
   func filterDuplicate<T>(_ keyValue:(Element)->T) -> [Element]
   {
      var uniqueKeys = Set<String>()
      return filter{uniqueKeys.insert("\(keyValue($0))").inserted}
   }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UserDefaults {
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }

    enum Keys: String, CaseIterable {

        case unitsNotation
        case temperatureNotation
        case allowDownloadsOverCellular

    }

    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}

extension UIApplicationDelegate {
    func setQuizzesRootController() {
        let quizTableItem = UITabBarItem()
        quizTableItem.title = "Quizzes"
        quizTableItem.image = UIImage(systemName: "list.dash")
        
        let quizTableViewController = QuizTableViewController()
        
        let quizTableNavigationController = UINavigationController(rootViewController: quizTableViewController)
        quizTableNavigationController.tabBarItem = quizTableItem
        
        let settingsItem = UITabBarItem()
        settingsItem.title = "Settings"
        settingsItem.image = UIImage(systemName: "gear")
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = settingsItem
        
        let searchItem = UITabBarItem()
        searchItem.title = "Search"
        searchItem.image = UIImage(systemName: "magnifyingglass")
        
        let searchViewController = SearchViewController()
        
        let searchViewNaviationController = UINavigationController(rootViewController: searchViewController)
        searchViewNaviationController.tabBarItem = searchItem
        
        let rootViewController = UITabBarController()
        rootViewController.viewControllers = [quizTableNavigationController, settingsViewController, searchViewNaviationController]
        
        self.window??.rootViewController = rootViewController
    }
    
    func setLoginRootController() {
        self.window??.rootViewController = LoginViewController()
    }
}
