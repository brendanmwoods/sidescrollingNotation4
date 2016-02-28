//
//  ViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-10.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
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
    
    var scoresArray:NSMutableArray!
    var plistPath:String!
    
    let topLineY:CGFloat = 100
    var screenWidth:CGFloat = 0
    var distanceToMoveNoteLeft:CGFloat = 0
    let fractionOfTheScreenToMoveNote = 320
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
    var currentScore = 0
    var nextScoreIncrease = 0
    let scoreIncreaseConstant = 100
    var scoresNeedResetting = false
    var difficulty = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = UIScreen.mainScreen().bounds.width
        distanceToMoveNoteLeft = screenWidth / CGFloat(fractionOfTheScreenToMoveNote)
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
        if scoresNeedResetting
        {
            currentScore = 0
            scoreLabel!.text = String(currentScore)
            scoresNeedResetting = false
        }
        
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
                screenWidth - ovalNoteWidth,
                topLineY + CGFloat(currentNote.diffFromTop) * spaceBetweenNotes,
                ovalNoteWidth,
                ovalNoteHeight)
            
            view.addSubview(ovalNoteImageView)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(currentScrollSpeed, target: self,
                selector: Selector("moveOvalNoteLeft"), userInfo: nil, repeats: true)
            
    }
    
    
    
    //moves the note left. gets called repeatedly until timer is invalidated.
    func moveOvalNoteLeft(){
        
        if ovalNoteImageView.frame.origin.x <= 0 {
            currentScrollSpeed = startingScrollSpeed
            gameOver = true
            scoresNeedResetting = true
            timer.invalidate()
            gameOverAlert()
        } else {
            self.ovalNoteImageView.center.x -= distanceToMoveNoteLeft
        }
    }
    
    func correctGuess() {
        timer.invalidate()
        currentScrollSpeed /= 1.2
        currentScore++
        scoreLabel!.text = String(currentScore)
        gameLoop()
        
    }
    
    func incorrectGuess() {
        gameOver = true
        timer.invalidate()
        currentScrollSpeed = startingScrollSpeed
        scoresNeedResetting = true
        gameOverAlert()
    }
    
    
    func gameOverAlert(){
        saveScoreToScoresPlist()
        let alert = UIAlertController(title: "Game Over", message: "You scored : \(currentScore)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: {
            action in
            self.gameLoop()
        }))
        
        alert.addAction(UIAlertAction(title: "Main Menu", style: UIAlertActionStyle.Default, handler: {
            action in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func saveScoreToScoresPlist() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        if(difficulty == "easyTreble") {
            let pathForThePlistFile = appDelegate.easyTreblePlistPathInDocument
            
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(pathForThePlistFile)!
            
            do{
                let notesArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
                notesArray.addObject(String(self.currentScore))
                
                notesArray.writeToFile(pathForThePlistFile, atomically: true)
            }catch{
                print("An error occurred while writing to plist")
            }
        }
        
        
        if(difficulty == "easyBass") {
            let pathForThePlistFile = appDelegate.easyBassPlistPathInDocument
            
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(pathForThePlistFile)!
            
            do{
                let notesArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
                notesArray.addObject(String(self.currentScore))
                
                notesArray.writeToFile(pathForThePlistFile, atomically: true)
            }catch{
                print("An error occurred while writing to plist")
            }
        }
        
        
        if(difficulty == "medium") {
            let pathForThePlistFile = appDelegate.mediumPlistPathInDocument
            
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(pathForThePlistFile)!
            
            do{
                
                let notesArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
                notesArray.addObject(String(self.currentScore))
                
                notesArray.writeToFile(pathForThePlistFile, atomically: true)
            }catch{
                print("An error occurred while writing to plist")
            }
        }
        
    }
    
    
    @IBAction func noteButtonPushed(sender:UIButton) {
        
        if sender.titleLabel!.text!.lowercaseString == currentNote.noteName {
            // animate a color change of the key pushed
            sender.backgroundColor = UIColor.greenColor()
            UIView.animateWithDuration(1.0, animations: {
                sender.backgroundColor = UIColor.whiteColor()
            })
            correctGuess()
        }else {
            incorrectGuess()
            // animate a color change of the key pushed
            sender.backgroundColor = UIColor.redColor()
            UIView.animateWithDuration(1.0, animations: {
                sender.backgroundColor = UIColor.whiteColor()
            })
        }
    }
    
}


