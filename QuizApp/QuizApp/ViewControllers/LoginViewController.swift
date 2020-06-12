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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var credentialsIncorrectLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordInput.delegate = self
        
        animateX()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateAlpha()
    }
    
    func animateAlpha() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.loginLabel.alpha = 1
            self.usernameInput.alpha = 1
            self.usernameLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.passwordInput.alpha = 1
            self.passwordLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseInOut, animations: {
            self.loginButton.alpha = 1
        }, completion: nil)
    }
    
    func animateX() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.usernameInput.transform = CGAffineTransform(translationX: self.usernameInput.bounds.origin.x + 320, y: self.usernameInput.bounds.origin.y)
            self.usernameLabel.transform = CGAffineTransform(translationX: self.usernameLabel.bounds.origin.x + 320, y: self.usernameLabel.bounds.origin.y)
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.passwordInput.transform = CGAffineTransform(translationX: self.passwordInput.bounds.origin.x + 320, y: self.passwordInput.bounds.origin.y)
            self.passwordLabel.transform = CGAffineTransform(translationX: self.passwordLabel.bounds.origin.x + 320, y: self.passwordLabel.bounds.origin.y)
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseInOut, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: self.loginButton.bounds.origin.x + 320, y: self.loginButton.bounds.origin.y)
        }, completion: nil)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }
    
    func animateOut() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.loginLabel.transform = CGAffineTransform(translationX: self.usernameInput.bounds.origin.x, y: self.usernameInput.bounds.origin.y - 200)
            self.loginLabel.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.usernameInput.transform = CGAffineTransform(translationX: self.usernameInput.bounds.origin.x, y: self.usernameInput.bounds.origin.y - 200)
            self.usernameLabel.transform = CGAffineTransform(translationX: self.usernameLabel.bounds.origin.x, y: self.usernameLabel.bounds.origin.y - 200)
            self.usernameInput.alpha = 0
            self.usernameLabel.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 1.0, options: .curveEaseInOut, animations: {
            self.passwordInput.transform = CGAffineTransform(translationX: self.passwordInput.bounds.origin.x, y: self.passwordInput.bounds.origin.y - 200)
            self.passwordLabel.transform = CGAffineTransform(translationX: self.passwordLabel.bounds.origin.x, y: self.passwordLabel.bounds.origin.y - 200)
            self.passwordLabel.alpha = 0
            self.passwordInput.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseInOut, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: self.loginButton.bounds.origin.x, y: self.loginButton.bounds.origin.y - 200)
            self.loginButton.alpha = 0
        }, completion: nil)
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
                    self.animateOut()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.setQuizzesRootController()
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
