//
//  OptionsViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-01.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import Firebase

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton:UIButton!
    
    var isSound = true
    var appDelegate = AppDelegate()
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        soundSwitch.on = appDelegate.isSound
        setUsernameLabel()
        setLogoutButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLogoutButton() {
        if loggedIn == true {
            logoutButton.setTitle("Logout", forState: .Normal)
        } else if loggedIn == false {
            logoutButton.setTitle("Login", forState: .Normal)
        }
    }
    
    func setUsernameLabel(){
        
        let defaults = NSUserDefaults()
        
        if defaults.valueForKey("FirebaseUsername") == nil {
            usernameLabel.text = "Not logged in"
            loggedIn = false
        }else {
            usernameLabel.text = defaults.valueForKey("FirebaseUsername") as? String
            loggedIn = true
        }
    }
    
    @IBAction func soundSwitched(sender:UISwitch) {
        let defaults = NSUserDefaults()
        
        if sender.on {
            appDelegate.isSound = true
            defaults.setValue(true, forKey: "isSound")
        } else {
            appDelegate.isSound = false
            defaults.setValue(false, forKey: "isSound")
        }
    }
    
    @IBAction func logoutOfFirebase() {
        if loggedIn == true {
        let defaults = NSUserDefaults()
         //remove push notification token from firebase
        let tokenRef = Firebase(url:"https://glowing-torch-8861.firebaseio.com/Usernames/\(defaults.valueForKey("FirebaseUsername")!)/token")
            
        tokenRef.removeValue()
            
        defaults.setValue(nil, forKey: "FirebaseUID")
        defaults.setValue(nil, forKey: "FirebaseUsername")
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.allPlayerScores = [Int]()
        setUsernameLabel()
        logoutButton.setTitle("Login", forState: .Normal)
        loggedIn = false
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.highScore = 0
            
            
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("signInScene") as! SignInViewController
            self.showViewController(vc, sender: vc)
        }
    }
    
}
