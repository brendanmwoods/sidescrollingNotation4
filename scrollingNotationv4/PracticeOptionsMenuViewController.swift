//
//  PracticeOptionsMenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-04-05.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class PracticeOptionsMenuViewController: UIViewController {
    var appDelegate = AppDelegate()
    
    @IBOutlet weak var noteRangeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    @IBAction func noteRangeControlPushed(sender: AnyObject) {
        print(noteRangeControl.selectedSegmentIndex)
        if noteRangeControl.selectedSegmentIndex == 0 {
            appDelegate.practiceModeDifficulty = "easyBass"
        } else if noteRangeControl.selectedSegmentIndex == 1 {
            appDelegate.practiceModeDifficulty = "medium"
        } else if noteRangeControl.selectedSegmentIndex == 2 {
            appDelegate.practiceModeDifficulty = "easyTreble"
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
