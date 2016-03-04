//
//  LearningMenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-17.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class LearningMenuViewController: UIViewController {
    
    @IBOutlet weak var easyTrebleButton: UIButton!
    @IBOutlet weak var easyBassButton:   UIButton!
    @IBOutlet weak var mediumButton:     UIButton!
    @IBOutlet weak var noteChartButton:  UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Learning Mode"
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
        
        noteChartButton.layer.borderColor = UIColor.blackColor().CGColor
        noteChartButton.layer.borderWidth = 2
        noteChartButton.layer.cornerRadius = 5

    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "easyTrebleSegue") {
            let destinationVC = segue.destinationViewController as! LearningViewController
            destinationVC.difficulty = "easyTreble"
        }
        
        if(segue.identifier == "easyBassSegue") {
            let destinationVC = segue.destinationViewController as! LearningViewController
            destinationVC.difficulty = "easyBass"
        }
        if (segue.identifier == "mediumSegue") {
            let destinationVC = segue.destinationViewController as! LearningViewController
            destinationVC.difficulty = "medium"
        }
    }
    
    
}