//
//  LoginViewController.swift
//  MicroChat
//
//  Created by Daniel Li on 5/26/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBAction func enterButtonPressed(sender: UIButton) {
        if signUp {
            Network.signUp(nameField.text!, email: emailField.text!, password: passwordField.text!) { error in
                if let error = error { self.displayError(error, completion: nil); return }
                NSNotificationCenter.defaultCenter().postNotificationName(UserDidSignUpNotification, object: nil)
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
            
            signUp ? nameField.fadeShow() : nameField.fadeHide()
            nameFieldHeight.constant = signUp ? 44.0 : 0.0
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
