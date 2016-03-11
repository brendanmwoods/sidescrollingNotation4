//
//  SignInViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-09.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accountStatusLabel: UILabel!
    
    var optionalPrefilledEmail: String = ""
    var optionalPrefilledPassword: String = ""
    var ref = Firebase(url:"https://glowing-torch-8861.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        emailTextField.text = optionalPrefilledEmail
        passwordTextField.text = optionalPrefilledPassword
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInPushed(sender: UIButton) {

        ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: {error, authData in
            if error != nil {
                self.accountStatusLabel.hidden = false
                self.accountStatusLabel.text = error.description
                
            }else {
                let uid = authData.uid
                self.accountStatusLabel.hidden = false
                self.accountStatusLabel.text = "Logged in"
                let defaults = NSUserDefaults()
                defaults.setValue(uid, forKey: "FirebaseUID")
                let nameRef = Firebase(url:"https://glowing-torch-8861.firebaseio.com/Usernames")
                nameRef.queryOrderedByChild("UID").queryEqualToValue(uid)
                    .observeEventType(.ChildAdded, withBlock: { snapshot in
                        defaults.setValue(snapshot.key!, forKey: "FirebaseUsername")
                    })
               
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mainMenuScene") as! MainMenuViewController
                vc.didJustLoginInPreviousScreen = true
                self.showViewController(vc, sender: vc)
            }
        })
    }
    
}
