//
//  MenuViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-17.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {

    @IBOutlet weak var easyTrebleButton: UIButton!
    @IBOutlet weak var easyBassButton:   UIButton!
    @IBOutlet weak var mediumButton:     UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatButtons()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatButtons() {
        easyTrebleButton.layer.borderColor = self.view.tintColor.CGColor
        easyTrebleButton.layer.borderWidth = 1
        easyTrebleButton.layer.cornerRadius = 10
        
        easyBassButton.layer.borderColor = self.view.tintColor.CGColor
        easyBassButton.layer.borderWidth = 1
        easyBassButton.layer.cornerRadius = 10
        
        mediumButton.layer.borderColor = self.view.tintColor.CGColor
        mediumButton.layer.borderWidth = 1
        mediumButton.layer.cornerRadius = 10
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
    }

}
