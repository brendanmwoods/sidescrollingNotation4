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
    var difficulty = ""
    var highScore = 99
    var totalScores = 0
    var averageScore:Double = 0
    let graphButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let backItem = UIBarButtonItem(title: "Stats", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        getScoresData()
        setTitle()
        calculateHighScore()
        calculateAverageScore()
        self.tableView.reloadData()
    }
    
    func calculateAverageScore() {
        if scoresArray.count > 0 {
            var totalPoints = 0
            for score in scoresArray as NSArray as! [String] {
                totalPoints += Int(score)!
            }
            let x = Double(totalPoints) / Double(scoresArray.count)
            averageScore = Double(round(100*x)/100)
        }else {
            averageScore = 0
        }
    }
    
    
    func setTitle() {
        totalScores = scoresArray.count
        if difficulty == "easyTreble" {
            self.title = "Treble Clef Stats"
        }else if difficulty == "easyBass" {
            self.title = "Bass Clef Stats"
        }else if difficulty == "medium"{
            self.title = "Full Clef Stats"
        }
    }
    
    
    func getScoresData() {
        if(difficulty == "easyTreble") {
            
            //get path to plist of all scores
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            plistPath = appDelegate.easyTreblePlistPathInDocument
            
            // Extract the content of the file as NSData
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
            do{
                scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
            }catch{
                print("Error occured while reading from the plist file")
            }
            
        } else if(difficulty == "easyBass") {
            
            //get path to plist of all scores
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            plistPath = appDelegate.easyBassPlistPathInDocument
            
            // Extract the content of the file as NSData
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
            do{
                scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
            }catch{
                print("Error occured while reading from the plist file")
            }
        }
            
            
        else if(difficulty == "medium") {
            
            //get path to plist of all scores
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            plistPath = appDelegate.mediumPlistPathInDocument
            
            // Extract the content of the file as NSData
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
            do{
                scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
            }catch{
                print("Error occured while reading from the plist file")
            }
            
        }
    }
    
    
    func calculateHighScore() {
        highScore = 0
        for score in scoresArray as NSArray as! [String] {
            if Int(score) > Int(highScore) {
                highScore = Int(score)!
            }
        }
    }
    
    
    // Delete all scores from plist records, permanently
    func deleteAllScores() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        plistPath = appDelegate.easyTreblePlistPathInDocument
        
        // Extract the content of the file as NSData
        var data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
        do{
            scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
            
            for var i = scoresArray.count - 1; i >= 0; i-- {
                scoresArray.removeObjectAtIndex(i)
                scoresArray.writeToFile(plistPath, atomically: true)
            }
            
        }catch{
            print("Error occured while reading from the plist file")
        }
        
        
        
        plistPath = appDelegate.easyBassPlistPathInDocument
        
        // Extract the content of the file as NSData
        data =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
        do{
            scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
            
            for var i = scoresArray.count - 1; i >= 0; i-- {
                scoresArray.removeObjectAtIndex(i)
                scoresArray.writeToFile(plistPath, atomically: true)
            }
            
        }catch{
            print("Error occured while reading from the plist file")
        }
        
        
        plistPath = appDelegate.mediumPlistPathInDocument
        
        // Extract the content of the file as NSData
        data =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
        do{
            scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
            
            for var i = scoresArray.count - 1; i >= 0; i-- {
                scoresArray.removeObjectAtIndex(i)
                scoresArray.writeToFile(plistPath, atomically: true)
            }
            
        }catch{
            print("Error occured while reading from the plist file")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            if section == 0 {
                return 1
            } else if section == 1 {
                return 1
            } else if section == 2 {
                return 1
            }else if section == 3 {
                return 1
            }else if section == 4{
                if scoresArray.count < 5 {
                    return scoresArray.count
                } else {
                    return 5
                }
            }else {
                return 0
            }
    }
    
    
    // Generate the cell data for the sections
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            if indexPath.section == 0 {
                //the high score cell
                let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
                cell.textLabel!.text = "\(highScore)"
                cell.textLabel?.textAlignment = .Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.section == 1 {
                //the average score cell
                let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
                cell.textLabel!.text = "\(averageScore)"
                cell.textLabel?.textAlignment = .Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.section == 2 {
                //the number of games played cell
                let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
                cell.textLabel!.text = "\(scoresArray.count)"
                cell.textLabel?.textAlignment = .Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.section == 3 {
                // the cell for the graph button
                let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
                cell.textLabel?.textAlignment = .Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundColor = UIColor.blackColor()
                
                graphButton.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, cell.frame.size.height)
                graphButton.backgroundColor = UIColor(red: 225/255, green: 247/255, blue: 253/255, alpha: 1.0)
                graphButton.setTitle("Press To Graph", forState: UIControlState.Normal)
                graphButton.titleLabel?.textAlignment = .Left
                graphButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                graphButton.titleLabel!.font = UIFont.boldSystemFontOfSize(22)
                
                graphButton.layer.cornerRadius = 8
                graphButton.tag = 1
                graphButton.addTarget(self, action: "graphButtonPressed", forControlEvents: .TouchUpInside)
                cell.addSubview(graphButton)
                return cell
            }else {
                //the recent scores cells
                var reversedScoresArray = scoresArray as NSArray as! [String]
                reversedScoresArray = reversedScoresArray.reverse()
                let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
                cell.textLabel!.text = reversedScoresArray[indexPath.row]
                cell.textLabel?.textAlignment = .Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
    }
    
    func graphButtonPressed() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("graphViewID") as! GraphViewController
        vc.scoresArray = scoresArray as NSArray as! [String]
        vc.difficulty = difficulty
        vc.highScore = highScore
        self.showViewController(vc, sender: vc)
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        
        title.textColor = UIColor.whiteColor()
        title.backgroundColor = UIColor.blackColor()
        title.textAlignment = .Center
        
        if section == 0 {
            title.text = "High Score"
        }  else if section == 1 {
            title.text = "Average Score"
        }else if section == 2 {
            title.text = "Total Games Played"
        }else if section == 3{
            title.text = "Graph Scores"
        }else if section == 4{
            title.text = "Recent Scores"
        }
        return title
    }
}

//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "High Score"
//        }else if section == 1 {
//            return "Average Score"
//        }else if section == 2 {
//            return "Total Games Played"
//        }else if section == 3{
//            return "Recent Scores"
//        }else {
//            return " "
//        }




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


