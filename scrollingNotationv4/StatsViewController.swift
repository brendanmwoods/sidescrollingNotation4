//
//  StatsViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-14.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var  highScoreLabel:UILabel!
    @IBOutlet weak var  averageScoreLabel:UILabel!
    @IBOutlet weak var  gamesPlayedLabel:UILabel!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreLabel.text = "\(appDelegate.highScore)"
        gamesPlayedLabel.text = "\(appDelegate.allPlayerScores.count)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
