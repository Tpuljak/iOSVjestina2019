//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var credentialsIncorrectLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordInput.delegate = self
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(showing: true, notification: notification)
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(showing: false, notification: notification)
    }
    
    private func updateBottomLayoutConstraintWithNotification(showing: Bool, notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
        
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            else { return }
        
        let newHeight = showing ? (keyboardSize.size.height + 50) : (260)
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.init(rawValue: curve),
                       animations: {
                        self.bottomLayoutConstraint.constant = newHeight
        }, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        login()
    }
    
    func login() {
        let username = usernameInput.text!
        let password = passwordInput.text!
        
        DispatchQueue.global(qos: .utility).async {
            DispatchQueue.main.async {
                self.loginButton.isEnabled = false
            }
            let result = self.apiClient.authorize(username: username, password: password)
            
            switch (result) {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(QuizTableViewController(), animated: true)
                }
                break
            case .failure(_):
                DispatchQueue.main.async {
                    self.credentialsIncorrectLabel.isHidden = false
                }
            }
            
            DispatchQueue.main.async {
                self.loginButton.isEnabled = true
            }
        }
        
        
    }
}
