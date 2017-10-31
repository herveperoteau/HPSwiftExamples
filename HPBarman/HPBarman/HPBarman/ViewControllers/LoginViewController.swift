//
//  LoginViewController.swift
//  HPBarman
//
//  Created by Hervé Péroteau on 14/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {
    
    // MARK: - Private types
    private struct Segues {
        static let signInOK = "signInOk"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var sv_fields: UIStackView!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var bt_signIn: UIButton!
    @IBOutlet weak var bt_signUp: UIButton!
    
    // MARK: - Life Cycle
    deinit {
        print("\(self.classForCoder).deinit ...")
    }
    
    override func viewDidLoad() {
        
        print("\(self.classForCoder).viewDidLoad ...")
        
        super.viewDidLoad()
        
        tf_email.autocorrectionType = .no
        tf_password.autocorrectionType = .no
        tf_password.isSecureTextEntry = true
        
        sv_fields.setCustomSpacing(22.0, after: tf_password)
        sv_fields.setCustomSpacing(42.0, after: bt_signIn)
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if let user = user {
                Context.user = SpotUser(authData: user)
                self.performSegue(withIdentifier: Segues.signInOK, sender: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(self.classForCoder).viewDidAppear ...")
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        print("\(self.classForCoder).viewDidDisappear ...")
        
        super.viewDidDisappear(animated)
        tf_email.text = nil
        tf_password.text = nil
    }
    
    // MARK: - Actions
    @IBAction func signInDidTouch(_ sender: AnyObject) {
        Auth.auth().signIn(
            withEmail: tf_email.text!,
            password: tf_password.text!)
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default)
        { action in
            
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            Auth.auth().createUser(
                withEmail: emailField.text!,
                password: passwordField.text!)
            { user, error in
                
                guard error == nil else {
                    print("error=\(error!) !!!")
                    return
                }
                
                Auth.auth().signIn(
                    withEmail: emailField.text!,
                    password: passwordField.text!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_email {
            tf_password.becomeFirstResponder()
        }
        if textField == tf_password {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Navigation
extension LoginViewController {
    @IBAction func unwindToLoginViewController(segue:UIStoryboardSegue) {
        print("\(self.classForCoder).unwindToLoginViewController ...")
        do {
            try Auth.auth().signOut()
        } catch {
        }
    }
}


