//
//  MultiplayerMenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-20.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import Firebase

class MultiplayerMenuViewController: UIViewController {
    
    var delegate = AppDelegate()
    let ref = Firebase(url: "https://glowing-torch-8861.firebaseio.com/")
    
    @IBOutlet weak var containerForGames: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newGameButtonPushed(sender: AnyObject) {
        
        //promt the user to enter the oppenents username
        let alert = UIAlertController(title: "Search Username", message: "Enter the username you want to play with", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            let opponentName = alert.textFields![0].text
            if opponentName != "" && opponentName != nil {
                if opponentName! != self.delegate.username{
                    self.ref.childByAppendingPath("Usernames/\(opponentName!)").observeSingleEventOfType(.Value, withBlock: {
                        snapshot in
                        if snapshot.value is NSNull {
                            //username does not exist
                            self.invalidUsernameAlert(opponentName!)
                        } else {
                            //begin a new game
                            self.createNewGame(opponentName!)
                        }
                    })
                }
            }
        }))
        self.presentViewController(alert, animated: true, completion: {
        
        })
    }
    
    @IBAction func newGameVsRandomButtonPushed(sender:UIButton!) {
        
        let waitlistRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/MultiplayerWaitlist")
        
        waitlistRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.value is NSNull {
                //nobody in the waitlist, so add the player and alert them to wait
                waitlistRef.setValue([self.delegate.username : "true"])
                let alert = UIAlertController(title: "Searching...", message: "A game will be added when another player is found", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                waitlistRef.observeSingleEventOfType(.ChildAdded, withBlock: {
                    snap in
                    if snap.key == self.delegate.username {
                        let alreadyOnList = UIAlertController(title: "Still Searching...", message: "You are already on the waiitlist. A game will be added when another player is found.", preferredStyle: .Alert)
                    alreadyOnList.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alreadyOnList, animated: true, completion: nil)
                    }
                    else {
                        self.createNewGame(snap.key)
                        waitlistRef.removeValue()
                        let successAlert = UIAlertController(title: "Success", message: "New game added!", preferredStyle: .Alert)
                        successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(successAlert, animated: true, completion: nil)
                    }
                })
                
                
            }
            
        })
    }
    
    func createNewGame(opponent:String) {
        let playersGamesRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/Usernames/\(delegate.username)/games")
        let opponentsGamesRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/Usernames/\(opponent)/games")
        
        let gameId = ref.childByAppendingPath("Games/").childByAutoId()
        gameId.setValue(["Player1" : "\(self.delegate.username)",
            "Player2" : "\(opponent)", "scoreToBeat": 0, "isNewGame" : true])
        gameId.childByAppendingPath("waitingOnPlayer").setValue([self.delegate.username : "true"])
        gameId.childByAppendingPath("wins").setValue([self.delegate.username : 0, opponent: 0])
        let gameIdString = String(gameId.key)
        playersGamesRef.updateChildValues([gameIdString: "true"])
        opponentsGamesRef.updateChildValues([gameIdString: "true"])
        
    }
    
    
    func invalidUsernameAlert(name:String) {
        let invalidAlert = UIAlertController(title: "Invalid Username", message: "No user found with the name \(name)", preferredStyle: .Alert)
        invalidAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler:nil))
        self.presentViewController(invalidAlert, animated: true, completion: nil)
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
