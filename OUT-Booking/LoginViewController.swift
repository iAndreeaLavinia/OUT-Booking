//
//  ImagelocationViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var shouldLogin: Bool = false
    
    var isSignUp: Bool = false
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate to the current controller
        passwordTextField.delegate = self
        confirmPassword.delegate = self
        usernameTextField.becomeFirstResponder()
        passwordTextField.placeholder = "Password"
        shouldLogin = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Actions
    @IBAction func loginAction(_ sender: UIButton) {
        if isSignUp == true {
            isSignUp = false
            confirmPassword.isHidden = true
            loginButton.setTitle("LOGIN", for: .normal)
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            if usernameTextField.text?.isEmpty ?? true && passwordTextField.text?.isEmpty ?? true {
               
            } else {
               shouldLogin = true
               performSegue(withIdentifier: "unwindToMainViewController", sender: nil)
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        isSignUp = true
        confirmPassword.text = nil
        confirmPassword.isHidden = false
        loginButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitle("Login", for: .normal)
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
