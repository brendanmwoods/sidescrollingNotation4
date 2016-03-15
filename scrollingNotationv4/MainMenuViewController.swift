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
    var didJustLoginInPreviousScreen = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        formatButtons()
        
        if didJustLoginInPreviousScreen == true {
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.didJustLoginInPreviousScreen = false
        }
        
        // Make navigation bar transparent
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func formatButtons() {
//        learningMode.layer.borderColor = UIColor.blackColor().CGColor
//        learningMode.layer.borderWidth = 2
//        learningMode.layer.cornerRadius = 5
        
//        gameMode.layer.borderColor = UIColor.blackColor().CGColor
//        gameMode.layer.borderWidth = 2
//        gameMode.layer.cornerRadius = 2
        
//        options.layer.borderColor = UIColor.blackColor().CGColor
//        options.layer.borderWidth = 2
//        options.layer.cornerRadius = 5
        
    }
    
    @IBAction func gameButtonPushed(sender:UIButton) {
        let defaults = NSUserDefaults()
        if defaults.valueForKey("FirebaseUID") == nil{
            let vc = storyboard?.instantiateViewControllerWithIdentifier("createAccountScene") as! CreateAccountViewController
            self.showViewController(vc, sender: vc)
        } else {
            //logged in already. carry on to game.
            let vc = storyboard?.instantiateViewControllerWithIdentifier("gameMenuScene") as! GameMenuViewController
            self.showViewController(vc, sender: vc)
        }
    }
}
