//
//  leadboardTableTableViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-08.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class leadboardTableTableViewController: UITableViewController {
    let leaderboardSize = 100
    var leaderboardItems = [LeaderboardItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.backgroundColor = UIColor.whiteColor()
        self.title = "Leaderboard"
        makeLeaderboard()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return leaderboardSize
    }
    
    func makeLeaderboard() {
        let scoresRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/High%20Scores")
        
        scoresRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var newItems = [LeaderboardItem]()
            var childrenCount = 0
            
            for item in snapshot.children {
                if childrenCount < self.leaderboardSize {
                    let leaderboardItem = LeaderboardItem(snapshot: item as! FDataSnapshot)
                    newItems.append(leaderboardItem)
                    childrenCount++
                }
            }
            self.leaderboardItems = newItems
            self.reloadAllCells()
        })
    }
    
    func reloadAllCells() {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        if indexPath.row < leaderboardItems.count {
            cell.textLabel?.textAlignment = .Center
            cell.textLabel!.text = ("\(indexPath.row + 1). \(leaderboardItems[indexPath.row].name)")
            cell.detailTextLabel!.text = "      Score: \(leaderboardItems[indexPath.row].score)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
