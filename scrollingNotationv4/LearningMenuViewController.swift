//
//  LearningMenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-17.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class LearningMenuViewController: UIViewController {
    
    @IBOutlet weak var mediumButton:     UIButton!
    @IBOutlet weak var noteChartButton:  UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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