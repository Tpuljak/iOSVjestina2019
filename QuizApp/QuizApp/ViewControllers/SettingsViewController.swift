//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 09/06/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.reset()
        
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = LoginViewController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = UserDefaults.standard.string(forKey: "username")
    }
}
