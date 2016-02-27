//
//  MenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-17.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {
    
    @IBOutlet weak var easyTrebleButton:           UIButton!
    @IBOutlet weak var easyBassButton:             UIButton!
    @IBOutlet weak var mediumButton:               UIButton!
    @IBOutlet weak var easyTrebleScoresButton:     UIButton!
    @IBOutlet weak var easyBassScoresButton:       UIButton!
    @IBOutlet weak var mediumScoresButton:         UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game Mode"
        let backItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        formatButtons()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatButtons() {
        easyTrebleButton.layer.borderColor = UIColor.blackColor().CGColor
        easyTrebleButton.layer.borderWidth = 2
        easyTrebleButton.layer.cornerRadius = 5
        
        easyBassButton.layer.borderColor = UIColor.blackColor().CGColor
        easyBassButton.layer.borderWidth = 2
        easyBassButton.layer.cornerRadius = 5
        
        mediumButton.layer.borderColor = UIColor.blackColor().CGColor
        mediumButton.layer.borderWidth = 2
        mediumButton.layer.cornerRadius = 5
        
        easyTrebleScoresButton.layer.borderColor = UIColor.blackColor().CGColor
        easyTrebleScoresButton.layer.borderWidth = 2
        easyTrebleScoresButton.layer.cornerRadius = 5
        
        easyBassScoresButton.layer.borderColor = UIColor.blackColor().CGColor
        easyBassScoresButton.layer.borderWidth = 2
        easyBassScoresButton.layer.cornerRadius = 5
        
        mediumScoresButton.layer.borderColor = UIColor.blackColor().CGColor
        mediumScoresButton.layer.borderWidth = 2
        mediumScoresButton.layer.cornerRadius = 5
    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "easyTrebleSegue") {
            let destinationVC = segue.destinationViewController as! GameViewController
            destinationVC.difficulty = "easyTreble"
        }
        if(segue.identifier == "easyBassSegue") {
            let destinationVC = segue.destinationViewController as! GameViewController
            destinationVC.difficulty = "easyBass"
        }
        if (segue.identifier == "mediumSegue") {
            let destinationVC = segue.destinationViewController as! GameViewController
            destinationVC.difficulty = "medium"
        }
        if(segue.identifier == "easyTrebleScoresSegue") {
            let destinationVC = segue.destinationViewController as! ScoresTableViewController
            destinationVC.difficulty = "easyTreble"
        }
        if(segue.identifier == "easyBassScoresSegue") {
            let destinationVC = segue.destinationViewController as! ScoresTableViewController
            destinationVC.difficulty = "easyBass"
        }
        if(segue.identifier == "mediumScoresSegue") {
            let destinationVC = segue.destinationViewController as! ScoresTableViewController
            destinationVC.difficulty = "medium"
        }
    }
    
}
