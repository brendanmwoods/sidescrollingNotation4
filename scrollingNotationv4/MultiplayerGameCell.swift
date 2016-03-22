//
//  MultiplayerGameCell.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-20.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class MultiplayerGameCell: UITableViewCell {
    @IBOutlet weak var opponentLabel:UILabel!
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var scoreLabel:UILabel!
    @IBOutlet weak var waitingLabel:UIButton!
    
    var gameData = MultiplayerGamesTableViewController.gameData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
