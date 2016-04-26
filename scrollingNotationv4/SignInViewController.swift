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
    @IBOutlet weak var errorLabel:UILabel!
    
    var optionalPrefilledEmail: String = ""
    var optionalPrefilledPassword: String = ""
    var optionalprefilledAccountStatus: String = ""
    var ref = Firebase(url:"https://glowing-torch-8861.firebaseio.com/")
    var delegate = AppDelegate()
    var justCreatedAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        emailTextField.text = optionalPrefilledEmail
        passwordTextField.text = optionalPrefilledPassword
        
        if optionalprefilledAccountStatus != "" {
            accountStatusLabel.hidden = false
            accountStatusLabel.text = optionalprefilledAccountStatus
        }
        if justCreatedAccount {
            signIn()
        }
        
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInPushed(sender: UIButton) {
        signIn()
    }
    
    func signIn() {
        ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: {error, authData in
            if error != nil {
                self.errorLabel.hidden = false
                self.errorLabel.text = "Error signing in. Please confirm valid details. Error code:\(error.code)"
                
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
                        self.delegate.setUsername()
                        
                        //if a token exists , send it to firebase
                        if defaults.valueForKey("token") != nil {
                            //setting the token for the currennt device that the current user is loggin in with
                            let tokenRef = Firebase(url:"https://glowing-torch-8861.firebaseio.com/Usernames/\(defaults.valueForKey("FirebaseUsername")!)")
                            tokenRef.updateChildValues(["token" : defaults.valueForKey("token")!])
                            print(defaults.valueForKey("token"))
                        }
                    })
                
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let scoresRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/High%20Scores")
                scoresRef.queryOrderedByChild("UID").queryEqualToValue(defaults.valueForKey("FirebaseUID")).observeEventType(.ChildAdded, withBlock: {
                    snapshot in
                    let score:Int = snapshot.value["Score"] as! Int
                    appDelegate.allPlayerScores.append(score)
                    if score > appDelegate.highScore {
                        appDelegate.highScore = score
                    }
                })
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mainMenuScene") as! MainMenuViewController
                vc.didJustLoginInPreviousScreen = true
                self.showViewController(vc, sender: vc)
            }
        })
        
    }
}
