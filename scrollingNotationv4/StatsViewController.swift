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
        
        if appDelegate.allPlayerScores.count > 0 {
            var scoreTotal = 0
            for score in appDelegate.allPlayerScores {
                scoreTotal += score
            }
            let averageScore = Double(scoreTotal) / Double(appDelegate.allPlayerScores.count)
            let roundedAverageScore = Double(round(100*averageScore)/100)
            averageScoreLabel.text = String(roundedAverageScore)
        } else {
            averageScoreLabel.text = "0"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func graphButtonPressed(sender:UIButton) {
        if appDelegate.allPlayerScores.count > 1 {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("graphViewID") as! GraphViewController
            self.showViewController(vc, sender: vc)
        }
    }
}
