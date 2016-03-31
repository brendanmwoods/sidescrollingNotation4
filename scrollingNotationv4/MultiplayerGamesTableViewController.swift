//
//  MultiplayerGamesTableViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-20.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import Firebase

class MultiplayerGamesTableViewController: UITableViewController {
    var ref = Firebase(url: "https://glowing-torch-8861.firebaseio.com/")
    var gamesCount = 0
    var delegate = AppDelegate()
    var allGames = [gameData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        retrieveGamesData()
        self.tableView.rowHeight = 44.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func retrieveGamesData() {
        let gamesRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/Usernames/\(delegate.username)/games")
        
        //retrieve all games data, and listen for new games added. update table dynamically
        gamesRef.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            self.gamesCount = Int(snapshot.childrenCount)
            let gamesDataRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/Games/\(snapshot.key)")
            let gameID = snapshot.key
            gamesDataRef.observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                var opponentName = String()
                
                print(snapshot)
                if snapshot.value["Player1"] as! String == self.delegate.username {
                    opponentName = snapshot.value["Player2"] as! String
                } else {
                    opponentName = snapshot.value["Player1"] as! String
                }
                let scoreToBeat = snapshot.value["scoreToBeat"] as! Int
                let isNewGame = snapshot.value["isNewGame"] as! Bool
                var waitingOnPlayer = String()
                gamesDataRef.childByAppendingPath("waitingOnPlayer").observeSingleEventOfType(.ChildAdded, withBlock: {
                    snapshot in
                    waitingOnPlayer = snapshot.key
                })
                gamesDataRef.childByAppendingPath("wins").observeSingleEventOfType(.Value, withBlock: {
                    snapshot in
                    print(snapshot)
                    let heroWins = snapshot.value["\(self.delegate.username)"] as! Int
                    let opponentWins = snapshot.value["\(opponentName)"] as! Int
                    let tempGame = gameData(hero:self.delegate.username , opponent: opponentName, heroWins: heroWins, opponentWins: opponentWins, waitingOnPlayer: waitingOnPlayer, scoreToBeat: scoreToBeat, isNewGame: isNewGame, gameID: gameID )
                    self.allGames.append(tempGame)
                    self.tableView.reloadData()
                })
            })
        })
    }
    
    struct gameData {
        var hero = String()
        var opponent = String()
        var heroWins = 0
        var opponentWins = 0
        var waitingOnPlayer = String()
        var scoreToBeat = 0
        var isNewGame = true
        var gameID = String()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCells", forIndexPath: indexPath) as! MultiplayerGameCell
        cell.opponentLabel.text = "\(allGames[indexPath.row].opponent)"
        cell.scoreLabel.text = "\(allGames[indexPath.row].heroWins) - \(allGames[indexPath.row].opponentWins)"
        if allGames[indexPath.row].waitingOnPlayer == delegate.username {
            cell.playButton.hidden = false
            cell.waitingLabel.hidden = true
        }
        else {
            cell.playButton.hidden = true
            cell.waitingLabel.hidden = false
        }
        cell.gameData = allGames[indexPath.row]
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: "multiplayerGameSegue:", forControlEvents: .TouchUpInside)
        cell.deleteGameButton.tag = indexPath.row
        cell.deleteGameButton.addTarget(self, action: "deleteGameButtonPushed:", forControlEvents: .TouchUpInside)
        self.view.userInteractionEnabled = true
        cell.userInteractionEnabled = true
        return cell
    }
    
    func deleteGameButtonPushed(sender:UIButton!) {
        print("pushed by \(sender.tag)")
        let alert = UIAlertController(title: "Delete Game", message: "Are you sure you want to delete this game vs \(self.allGames[sender.tag].opponent)?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
            handler in
            self.ref.childByAppendingPath("Games/\(self.allGames[sender.tag].gameID)").removeValue()
            self.ref.childByAppendingPath("Usernames/\(self.allGames[sender.tag].hero)/games/\(self.allGames[sender.tag].gameID)").removeValue()
            self.ref.childByAppendingPath("Usernames/\(self.allGames[sender.tag].opponent)/games/\(self.allGames[sender.tag].gameID)").removeValue()
            self.allGames.removeAtIndex(sender.tag)
            self.tableView.reloadData()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func multiplayerGameSegue(sender:UIButton!) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("gameViewControllerScene") as! GameViewController
        vc.isMultiplayer = true
        vc.multiplayerData = allGames[sender.tag]
        vc.difficulty = "medium"
        self.showViewController(vc, sender: vc)
        
    }
    
}


/*
// Override to support conditional editing of the table view.
override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
// Return false if you do not want the specified item to be editable.
return true
}
*/

/*
// Override to support editing the table view.
override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
if editingStyle == .Delete {
// Delete the row from the data source
tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
} else if editingStyle == .Insert {
// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
}
}
*/

/*
// Override to support rearranging the table view.
override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
// Return false if you do not want the item to be re-orderable.
return true
}
*/