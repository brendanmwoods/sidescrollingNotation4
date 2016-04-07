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
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 29/255, green: 54/255, blue: 88/255, alpha: 1)
        self.view.backgroundColor = UIColor(red: 29/255, green: 54/255, blue: 88/255, alpha: 1)
        makeLeaderboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if leaderboardSize > leaderboardItems.count {
            return leaderboardItems.count
        }
        return leaderboardSize
    }
    
    func makeLeaderboard() {
        let scoresRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/High%20Scores")
        
        scoresRef.queryLimitedToFirst(100).observeSingleEventOfType(.Value, withBlock: { snapshot in
            var newItems = [LeaderboardItem]()
            var childrenCount = 0
            
            for item in snapshot.children {
                if childrenCount < self.leaderboardSize {
                    let leaderboardItem = LeaderboardItem(snapshot: item as! FDataSnapshot)
                    newItems.append(leaderboardItem)
                    childrenCount += 1
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
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = UIColor(red: 29/255, green: 54/255, blue: 88/255, alpha: 1)
        }
        return cell
    }
    
}
