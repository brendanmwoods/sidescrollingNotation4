//
//  ViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-10.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blankStaff: UIView?
    var ovalNoteImageView = UIImageView()
    
    
    let topLineY:CGFloat = 100
    var screenWidth:CGFloat = 0
    let ovalNoteWidth:CGFloat = 30
    let ovalNoteHeight:CGFloat = 20
    let spaceBetweenNotes:CGFloat = 10
    var timer = NSTimer()
    var noteLibrary = NoteLibrary()
    var gameOver = false
    var currentScrollSpeed:NSTimeInterval = 0.02
    var startingScrollSpeed:NSTimeInterval = 0.02
    var currentNote: (noteName: String,octaveNumber: Int,
    absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int) = ("",0,0,false,0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = UIScreen.mainScreen().bounds.width
        
        noteLibrary.fillNoteLibrary()
        noteLibrary.filterNotesForDifficulty("easyTreble")
        
        let imageName = "ovalNote.png"
        let image = UIImage(named: imageName)
        ovalNoteImageView = UIImageView(image: image!)
        
        startGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func startGame() {
        
        currentNote = noteLibrary.returnRandomNote()
        createOvalNoteImage(currentNote)
        
    }
    
    
    
    func createOvalNoteImage(note: (noteName: String,octaveNumber: Int,
        absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int)) {
            
            ovalNoteImageView.frame = CGRectMake(screenWidth - ovalNoteWidth,
                topLineY + CGFloat(currentNote.diffFromTop) * spaceBetweenNotes,
                ovalNoteWidth, ovalNoteHeight)
            
            view.addSubview(ovalNoteImageView)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(currentScrollSpeed, target: self,
                selector: Selector("moveOvalNoteLeft"), userInfo: nil, repeats: true)
            
    }
    
    
    
    //moves the note left. gets called repeatedly until timer is invalidated.
    func moveOvalNoteLeft(){
        
        if ovalNoteImageView.frame.origin.x <= 0 {
            currentScrollSpeed = startingScrollSpeed
            gameOver = true
            timer.invalidate()
            gameOverAlert()
        } else {
            
            self.ovalNoteImageView.center.x -= 1
        }
    }
    
    
    
    @IBAction func noteButtonPushed(sender:UIButton) {
        if sender.titleLabel!.text!.lowercaseString == currentNote.noteName {
            correctGuess()
        }else {
            incorrectGuess()
        }
    }
    
    func correctGuess() {
        timer.invalidate()
        currentScrollSpeed /= 1.25
        startGame()
        
    }
    
    func incorrectGuess() {
        gameOver = true
        timer.invalidate()
        currentScrollSpeed = startingScrollSpeed
        gameOverAlert()
    }
    
    
    func gameOverAlert(){
        let alert = UIAlertController(title: "Game Over", message: "You scored : ", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: {
            action in
            self.startGame()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func newGameButtonPushed() {
        timer.invalidate()
        startGame()
    }
}

