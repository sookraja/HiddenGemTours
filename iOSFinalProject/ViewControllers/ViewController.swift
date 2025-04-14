//
//  ViewController.swift
//  iOSFinalProject
//
//  Created by Blend Mustafa on 2025-04-09.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue)
    {
        
    }

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var msg : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            print("Missing email or password.")
            msg.text = "Missing email or password."
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }

            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                return
            }

            print("User logged in: \(authResult?.user.uid ?? "No UID")")
            
            self?.performSegue(withIdentifier: "login", sender: self)
        }

    }

    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            print("Missing email or password.")
            msg.text = "Missing email or password."
            return
        }

        guard Validator.isValidPassword(password) else {
                print("Password must be at least 8 characters.")
                msg.text = "Password must be at least 8 characters."
                return
            }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Signup error: \(error.localizedDescription)")
            } else {
                print("User signed up: \(authResult?.user.uid ?? "No UID")")
                self.msg.text = "Successfully registered"
                // Optionally auto-login or navigate
            }
        }
    }
    
    /*
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
    */


}
