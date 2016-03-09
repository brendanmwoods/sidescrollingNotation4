//
//  OptionsViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-01.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var usernameLabel: UILabel!

    var isSound = true
    var appDelegate = AppDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        soundSwitch.on = appDelegate.isSound
        setUsernameLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUsernameLabel(){
        if appDelegate.username.isEmpty {
            usernameLabel.text = "Username not yet set."
        } else {
            usernameLabel.text = "\(appDelegate.username)"
        }
    }
    
    @IBAction func soundSwitched(sender:UISwitch) {
        if sender.on {
            appDelegate.isSound = true
        } else {
            appDelegate.isSound = false
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
