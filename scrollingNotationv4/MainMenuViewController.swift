//
//  MainMenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-19.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var learningMode: UIButton!
    @IBOutlet weak var gameMode: UIButton!
    @IBOutlet weak var options: UIButton!
    var ratingMinSessions = 3
    var ratingTryAgainSessions = 5
    
    var didJustLoginInPreviousScreen = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if didJustLoginInPreviousScreen == true {
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.didJustLoginInPreviousScreen = false
        }
        
        // Make navigation bar transparent
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor(red: 17, green: 55, blue: 110, alpha: 1.0)
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        rateMe()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func rateMe() {
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        
        if (!neverRate && (numLaunches == ratingMinSessions || numLaunches >= (ratingMinSessions + ratingTryAgainSessions + 1)))
        {
            showPromptUserExperience()
            numLaunches = ratingMinSessions + 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    func showPromptUserExperience() {
        let alert = UIAlertController(title: "Thanks for using NoteRacer!", message: "Are you enjoying the app?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.showRateMe()
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "It could be better", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            //prompt for suggestions 
            let suggestionsAlert = UIAlertController(title: "How can we be better?", message: "Please send any improvements you would like to see to noteracer@gmail.com . Thanks!", preferredStyle: .Alert)
            suggestionsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(suggestionsAlert, animated: true, completion: nil)
        }))
 
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Rate Us", message: "Help with a quick rating?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Rate NoteRacer", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1093955366")!)
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func gameButtonPushed(sender:UIButton) {
        let defaults = NSUserDefaults()
        if defaults.valueForKey("FirebaseUID") == nil{
            let vc = storyboard?.instantiateViewControllerWithIdentifier("createAccountScene") as! CreateAccountViewController
            self.showViewController(vc, sender: vc)
        } else {
            performSegueWithIdentifier("gameSegue", sender: nil)
            
//            let vc = storyboard?.instantiateViewControllerWithIdentifier("gameMenuScene") as! GameMenuViewController
//            self.showViewController(vc, sender: vc)
        }
    }
}
