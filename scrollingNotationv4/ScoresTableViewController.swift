//
//  ScoresTableViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-18.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController {

    var scoresArray:NSMutableArray!
    var plistPath:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        plistPath = appDelegate.plistPathInDocument
        
        // Extract the content of the file as NSData
        let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
        do{
            scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("Error occured while reading from the plist file")
        }
        
        // TO DELETE AND OBJECT FROM LOCAL SCORES ARRAY
        // scoresArray.removeObjectAtIndex(0)
        // TO OVERWRITE EXISTING PLIST IN DOCS PATH
        // scoresArray.writeToFile(plistPath, atomically: true)
        self.tableView.reloadData()
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


    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
            cell.textLabel!.text = scoresArray.objectAtIndex(indexPath.row) as? String
            return cell
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            return scoresArray.count
    }
    
    
    //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }

    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
