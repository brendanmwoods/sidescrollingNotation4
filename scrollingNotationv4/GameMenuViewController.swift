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
    
    
    @IBOutlet weak var mediumButton:               UIButton!
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
        
        let backItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        makeLeaderboard()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidAppear(animated: Bool) {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "mediumSegue") {
            let destinationVC = segue.destinationViewController as! GameViewController
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

//
// xyz:
//  :player1
//      :wins 
//          :1
//      :isturn
//          :true
//      :scoreToBeat
//          :7
//  :player2
//      :wins 
//          :2
//      :isturn
//          :false
//      :scoreToBeat
//          :nil
// yyy:
//  :player1
//  :player3