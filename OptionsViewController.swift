//
//  OptionsViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-01.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    var isSound = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func soundSwitched(sender:UISwitch) {
        if sender.on {
            isSound = true
        } else {
            isSound = false
        }
        print(isSound)
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
