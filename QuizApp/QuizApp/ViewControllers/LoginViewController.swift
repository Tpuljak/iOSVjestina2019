//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var credentialsIncorrectLabel: UILabel!
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    @IBAction func loginAction(_ sender: Any) {
        let username = usernameInput.text!
        let password = passwordInput.text!
        
        DispatchQueue.global(qos: .utility).async {
            let result = self.apiClient.authorize(username: username, password: password)
            
            switch (result) {
                case let .success(data):
                    print(data)
                    break
                case let .failure(data):
                    print(data)
            }
        }
    }
}
