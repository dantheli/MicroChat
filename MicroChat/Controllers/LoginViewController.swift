//
//  LoginViewController.swift
//  MicroChat
//
//  Created by Daniel Li on 5/26/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var firstNameFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var lastNameFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBAction func enterButtonPressed(sender: UIButton) {
        if signUp {
            Network.signUp(firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, password: passwordField.text!) { error in
                if let error = error { self.displayError(error, completion: nil); return }
                Network.signIn(self.emailField.text!, password: self.passwordField.text!) { error in
                    if let error = error { self.displayError(error, completion: nil); return }
                    NSNotificationCenter.defaultCenter().postNotificationName(UserDidSignInNotification, object: nil)
                }
            }
        } else {
            Network.signIn(emailField.text ?? "", password: passwordField.text ?? "") { error in
                if let error = error { self.displayError(error, completion: nil); return }
                NSNotificationCenter.defaultCenter().postNotificationName(UserDidSignInNotification, object: nil)
            }
        }
    }
    
    @IBOutlet weak var switchButton: UIButton!
    @IBAction func switchButtonPressed(sender: UIButton) {
        signUp = !signUp
    }
    
    var signUp: Bool = false {
        didSet {
            enterButton.setTitle(signUp ? "sign up" : "sign in", forState: .Normal)
            switchButton.setTitle(signUp ? "already a user? sign in here." : "new user? sign up here.", forState: .Normal)
            
            if signUp {
                firstNameField.fadeShow()
                lastNameField.fadeShow()
                firstNameFieldHeight.constant = 44.0
                lastNameFieldHeight.constant = 44.0
            } else {
                firstNameField.fadeHide()
                lastNameField.fadeHide()
                firstNameFieldHeight.constant = 0.0
                lastNameFieldHeight.constant = 0.0
            }
            
            UIView.animateWithDuration(UIViewFadeDuration) {
                self.view.layoutSubviews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp = false
    }
    
    

}
