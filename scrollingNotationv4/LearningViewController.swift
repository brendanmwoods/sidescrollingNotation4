//
//  LearningViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-17.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class LearningViewController: UIViewController{
    // TO DO
    //remove all non-necessary game mode features
    //make not appear in horizontal center
    //give hints when wrong
    //note library returnRandomNote() shouldn't return same not twice in a row.
    @IBOutlet weak var blankStaff: UIView?
    @IBOutlet weak var aButton:UIButton?
    @IBOutlet weak var bButton:UIButton?
    @IBOutlet weak var cButton:UIButton?
    @IBOutlet weak var dButton:UIButton?
    @IBOutlet weak var eButton:UIButton?
    @IBOutlet weak var fButton:UIButton?
    @IBOutlet weak var gButton:UIButton?
    @IBOutlet weak var scoreLabel:UILabel?
    var ovalNoteImageView = UIImageView()
    
    
    let topLineY:CGFloat = 100
    var screenWidth:CGFloat = 0
    let ovalNoteWidth:CGFloat = 30
    let ovalNoteHeight:CGFloat = 20
    let spaceBetweenNotes:CGFloat = 10
    var noteLibrary = NoteLibrary()
    var currentNote: (noteName: String,octaveNumber: Int,
    absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int) = ("",0,0,false,0)
    var totalCorrect = 0
    var totalIncorrect = 0
    var difficulty = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = UIScreen.mainScreen().bounds.width
        formatButtonShapes()
        
        noteLibrary.fillNoteLibrary()
        noteLibrary.filterNotesForDifficulty(difficulty)
        
        let imageName = "ovalNote.png"
        let image = UIImage(named: imageName)
        ovalNoteImageView = UIImageView(image: image!)
        
        gameLoop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func gameLoop() {
        currentNote = noteLibrary.returnRandomNote()
        createOvalNoteImage(currentNote)
    }
    
    
    func formatButtonShapes() {
        let buttonRadius:CGFloat = 5
        aButton?.layer.cornerRadius = buttonRadius
        bButton?.layer.cornerRadius = buttonRadius
        cButton?.layer.cornerRadius = buttonRadius
        dButton?.layer.cornerRadius = buttonRadius
        eButton?.layer.cornerRadius = buttonRadius
        fButton?.layer.cornerRadius = buttonRadius
        gButton?.layer.cornerRadius = buttonRadius
    }
    
    
    func createOvalNoteImage(note: (noteName: String,octaveNumber: Int,
        absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int)) {
            
            ovalNoteImageView.frame = CGRectMake(
                (screenWidth/2) - (ovalNoteWidth/2),
                topLineY + CGFloat(currentNote.diffFromTop) * spaceBetweenNotes,
                ovalNoteWidth,
                ovalNoteHeight)
            
            view.addSubview(ovalNoteImageView)
    }
    
    func correctGuess() {
        totalCorrect++
        updateResultsLabel()
        gameLoop()
    }
    
    func incorrectGuess() {
        totalIncorrect++
        updateResultsLabel()
    }
    
    func updateResultsLabel() {
        scoreLabel!.text = String("\(totalCorrect) / \(totalCorrect + totalIncorrect)")
    }
    
    
//    func gameOverAlert(){
//        let alert = UIAlertController(title: "Game Over", message: "You scored : \(currentScore)", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: {
//            action in
//            self.gameLoop()
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
    
    
    @IBAction func noteButtonPushed(sender:UIButton) {
        if sender.titleLabel!.text!.lowercaseString == currentNote.noteName {
            correctGuess()
        }else {
            incorrectGuess()
        }
    }
}