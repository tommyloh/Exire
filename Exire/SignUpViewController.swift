//
//  SignUpViewController.swift
//  Exire
//
//  Created by Tommy Loh on 21/07/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var fireBaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUpButtonPressed(sender: AnyObject) {
        guard let email = emailTextField.text, let password = passwordTextField.text
            else{
                return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user{
                let userDict = ["email": email,  "signInCount": 1]
                
                self.fireBaseRef.child("users").child(user.uid).setValue(userDict)
                
                User.signIn(user.uid)
                
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
            }
            else
            {
                
                let controller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissButton = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                controller.addAction(dismissButton)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        })
    }
}

