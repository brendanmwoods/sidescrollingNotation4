//
//  CreateAccountViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-09.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import Firebase
class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accountStatusLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    let ref = Firebase(url: "https://glowing-torch-8861.firebaseio.com/")
    var accountCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createAccountPushed(sender: UIButton) {
        let usernamesRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/Usernames")
        if self.usernameTextField.text?.characters.count < 3 || self.usernameTextField.text?.characters.count > 12 {
            accountStatusLabel.text = "Username must be 3-12 characters in length"
            accountStatusLabel.hidden = false
        }
        else if self.usernameTextField.text == "" || self.emailTextField.text == "" || self.passwordTextField.text == "" {
            accountStatusLabel.text = "All fields must be filled"
            accountStatusLabel.hidden = false
        } else {
            usernamesRef.childByAppendingPath(usernameTextField.text).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                if snapshot.value is NSNull {
                    print("unique")
                    self.ref.createUser(self.emailTextField.text, password: self.passwordTextField.text, withValueCompletionBlock: {error, result in
                        if error != nil{
                            self.accountStatusLabel.text = error.localizedDescription
                            self.accountStatusLabel.hidden = false
                            print(error)
                        } else {
                            print("user created")
                            self.accountStatusLabel.hidden = false
                            self.accountStatusLabel.text = "Success"
                            let uid = result["uid"] as? String
                            let usernameAndUID = ["Username" : self.usernameTextField.text!, "UID" : uid!]
                            usernamesRef.childByAppendingPath(self.usernameTextField.text).setValue(usernameAndUID)
                            self.accountCreated = true
                            
                            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("signInScene") as! SignInViewController
                            vc.optionalPrefilledEmail = self.emailTextField.text!
                            vc.optionalPrefilledPassword = self.passwordTextField.text!
                            vc.optionalprefilledAccountStatus = "Success. Now Login"
                            vc.justCreatedAccount = true
                            self.showViewController(vc, sender: vc)
                        }
                    })
                } else {
                    print("not unique")
                    self.accountStatusLabel.hidden = false
                    self.accountStatusLabel.text = "Username already taken. Try again."
                }
            })
        }
    }    
}
