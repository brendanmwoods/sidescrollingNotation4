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
    
    
    let topLineY:CGFloat = 100
    var screenWidth:CGFloat = 0
    let ovalNoteWidth:CGFloat = 30
    let ovalNoteHeight:CGFloat = 20
    let spaceBetweenNotes:CGFloat = 10
    var timer = NSTimer()
    var ovalNoteImageView = UIImageView()
    var noteLibrary = NoteLibrary()
    var gameOver = false
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

        timer = NSTimer.scheduledTimerWithTimeInterval(startingScrollSpeed, target: self,
            selector: Selector("moveOvalNoteLeft"), userInfo: nil, repeats: true)
            
    }
    
    
    
    //moves the note left. gets called repeatedly until timer is invalidated.
    func moveOvalNoteLeft(){
        
        if ovalNoteImageView.frame.origin.x <= 0 {
            print("GAME OVER")
            gameOver = true
            timer.invalidate()
        } else {
            
            ovalNoteImageView.frame.origin.x -= 1
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
        print("CORRECT")
        timer.invalidate()
        startGame()
        
    }
    
    func incorrectGuess() {
        print("game over")
        gameOver = true
        timer.invalidate()
    }
}

