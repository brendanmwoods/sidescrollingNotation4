//
//  MenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-17.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class GameMenuViewController: UIViewController {
    
    @IBOutlet weak var easyTrebleButton:           UIButton!
    @IBOutlet weak var easyBassButton:             UIButton!
    @IBOutlet weak var mediumButton:               UIButton!
    @IBOutlet weak var easyTrebleScoresButton:     UIButton!
    @IBOutlet weak var easyBassScoresButton:       UIButton!
    @IBOutlet weak var mediumScoresButton:         UIButton!
    @IBOutlet weak var fullLeaderboardButton:      UIButton!
    @IBOutlet weak var leaderboardScore1:          UILabel!
    @IBOutlet weak var leaderboardScore2:          UILabel!
    @IBOutlet weak var leaderboardScore3:          UILabel!
    @IBOutlet weak var leaderboardScore4:          UILabel!
    @IBOutlet weak var leaderboardScore5:          UILabel!
    
    var appDelegate = AppDelegate()
    var ref = Firebase(url:"https://glowing-torch-8861.firebaseio.com")
    var leaderboardItems = [LeaderboardItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieveLeaderBoardData()
        self.title = "Game Mode"
        let backItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        formatButtons()
        makeLeaderboard()
    }
    
    override func viewDidAppear(animated: Bool) {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        checkForUsername()
    }
    
    func checkForUsername() {
        //if a username hasn't been set, then ask for one
        if appDelegate.username == "" {
            
            //create alert
            let alert = UIAlertController(title: "Set Username", message: "Please set a unique Username. This can only be set once, and cannot be edited. Must be 3 - 12 characters.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = ""
            })
            //submit the username attempt
            alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) ->
                Void in
                //create a refence to the url of the submitted username
                let textField = alert.textFields![0].text!
                let namesRef = self.ref.childByAppendingPath("/usernames/\(textField)")
                
                //check if the string is not blank characters
                if textField.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" && textField.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count > 2 {
                    
                    //check if the username exists
                    namesRef.observeSingleEventOfType(.Value, withBlock: {
                        snap in
                        if snap.value is NSNull {
                            let userNameAndUUID = ["Username" : textField, "UUID" : self.appDelegate.UUID]
                            namesRef.setValue(userNameAndUUID)
                            self.appDelegate.username = textField
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setObject(textField, forKey: "Username")
                        }else {
                            self.usernameTakenRetry()
                        }
                    })
                }else {
                    self.usernameTakenRetry()
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func usernameTakenRetry(){
        
        //loop through this until a valid name is entered
        print(appDelegate.username)
        if appDelegate.username == "" {
            //create alert
            let alert = UIAlertController(title: "Set Username", message: "Username is already taken, or is invalid. Please try again", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = ""
            })
            //submit the username attempt
            alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) ->
                Void in
                //create a refence to the url of the submitted username
                let textField = alert.textFields![0].text!
                let namesRef = self.ref.childByAppendingPath("/usernames/\(textField)")
                
                //check if the name is a non blank string
                if textField.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
                    
                    //check if the username exists
                    namesRef.observeSingleEventOfType(.Value, withBlock: {
                        snap in
                        if snap.value is NSNull {
                            let userNameAndUUID = ["Username" : textField, "UUID" : self.appDelegate.UUID]
                            namesRef.setValue(userNameAndUUID)
                            self.appDelegate.username = textField
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setObject(textField, forKey: "Username")
                        }else {
                            self.usernameTakenRetry()
                        }
                    })
                }else {
                    self.usernameTakenRetry()
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatButtons() {
        //        easyTrebleButton.layer.borderColor = UIColor.blackColor().CGColor
        //        easyTrebleButton.layer.borderWidth = 2
        //        easyTrebleButton.layer.cornerRadius = 5
        
        //        easyBassButton.layer.borderColor = UIColor.blackColor().CGColor
        //        easyBassButton.layer.borderWidth = 2
        //        easyBassButton.layer.cornerRadius = 5
        
        mediumButton.layer.borderColor = UIColor.blackColor().CGColor
        mediumButton.layer.borderWidth = 2
        mediumButton.layer.cornerRadius = 5
        
        //        easyTrebleScoresButton.layer.borderColor = UIColor.blackColor().CGColor
        //        easyTrebleScoresButton.layer.borderWidth = 2
        //        easyTrebleScoresButton.layer.cornerRadius = 5
        //
        //        easyBassScoresButton.layer.borderColor = UIColor.blackColor().CGColor
        //        easyBassScoresButton.layer.borderWidth = 2
        //        easyBassScoresButton.layer.cornerRadius = 5
        
        mediumScoresButton.layer.borderColor = UIColor.blackColor().CGColor
        mediumScoresButton.layer.borderWidth = 2
        mediumScoresButton.layer.cornerRadius = 5
        
        fullLeaderboardButton.layer.borderColor = UIColor.blackColor().CGColor
        fullLeaderboardButton.layer.borderWidth = 2
        fullLeaderboardButton.layer.cornerRadius = 5
    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "easyTrebleSegue") {
            let destinationVC = segue.destinationViewController as! GameViewController
            destinationVC.difficulty = "easyTreble"
        }
        if(segue.identifier == "easyBassSegue") {
            let destinationVC = segue.destinationViewController as! GameViewController
            destinationVC.difficulty = "easyBass"
        }
        if (segue.identifier == "mediumSegue") {
            let destinationVC = segue.destinationViewController as! GameViewController
            destinationVC.difficulty = "medium"
        }
        if(segue.identifier == "easyTrebleScoresSegue") {
            let destinationVC = segue.destinationViewController as! ScoresTableViewController
            destinationVC.difficulty = "easyTreble"
        }
        if(segue.identifier == "easyBassScoresSegue") {
            let destinationVC = segue.destinationViewController as! ScoresTableViewController
            destinationVC.difficulty = "easyBass"
        }
        if(segue.identifier == "mediumScoresSegue") {
            let destinationVC = segue.destinationViewController as! ScoresTableViewController
            destinationVC.difficulty = "medium"
        }
    }
    
    func populateLeaderBoard() {
        
        if leaderboardItems.count > 4 {
        leaderboardScore1.text = "1.  \(leaderboardItems[0].score) - \(leaderboardItems[0].name!)"
        leaderboardScore2.text = "2.  \(leaderboardItems[1].score) - \(leaderboardItems[1].name!)"
        leaderboardScore3.text = "3.  \(leaderboardItems[2].score) - \(leaderboardItems[2].name)"
        leaderboardScore4.text = "4.  \(leaderboardItems[3].score) - \(leaderboardItems[3].name)"
        leaderboardScore5.text = "5.  \(leaderboardItems[4].score) - \(leaderboardItems[4].name)"
        } else {
            leaderboardScore1.text = "More scores needed"
            leaderboardScore2.text = "More scores needed"
            leaderboardScore3.text = "More scores needed"
            leaderboardScore4.text = "More scores needed"
            leaderboardScore5.text = "More scores needed"
            
        }
    }
    
    @IBAction func addNamesToLeaderboard(sender:UIButton) {
        populateLeaderBoard()
    }
    
    func makeLeaderboard() {
        let scoresRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/High%20Scores")
        
        scoresRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var newItems = [LeaderboardItem]()
            var childrenCount = 0
            
            for item in snapshot.children {
                if childrenCount < 5 {
                let leaderboardItem = LeaderboardItem(snapshot: item as! FDataSnapshot)
                newItems.append(leaderboardItem)
                childrenCount++
                }
            }
            self.leaderboardItems = newItems
            self.populateLeaderBoard()
        })
    }
}
