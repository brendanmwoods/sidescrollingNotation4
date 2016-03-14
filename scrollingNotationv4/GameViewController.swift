//
//  ViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-10.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class GameViewController: UIViewController , AVAudioPlayerDelegate{
    
    @IBOutlet weak var blankStaff: UIView?
    @IBOutlet weak var aButton:UIButton?
    @IBOutlet weak var bButton:UIButton?
    @IBOutlet weak var cButton:UIButton?
    @IBOutlet weak var dButton:UIButton?
    @IBOutlet weak var eButton:UIButton?
    @IBOutlet weak var fButton:UIButton?
    @IBOutlet weak var gButton:UIButton?
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var highScoreLabel:UILabel?
    
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
    var notePlayer: AVAudioPlayer! = nil
    var highScore = 0
    var appDelegate = AppDelegate()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
    
    
    func postPreDbScores() {
        let highScoresRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/High%20Scores")
        
        //get path to plist of all scores
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        plistPath = appDelegate.mediumPlistPathInDocument
        
        // Extract the content of the file as NSData
        let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
        do{
            scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
            
        }catch{
            print("Error occured while reading from the plist file")
        }
        
        for score in scoresArray as NSArray as! [String] {
            let theScore:Int = Int(score)!
            let score1 = ["Score" : theScore, "Name" : appDelegate.username, "UUID" : appDelegate.UUID, "Date": NSDate().timeIntervalSince1970]
            
            highScoresRef.childByAutoId().setValue(score1, andPriority: 0 - Int(theScore))
        }
        print("posted all scores")
    }
    
    func postScoreToFirebase() {
        let defaults = NSUserDefaults()
        let highScoresRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/High%20Scores")

        let uid = defaults.valueForKey("FirebaseUID")
        //get path to plist of all scores
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let theScore = currentScore
            let score1 = ["Score" : theScore, "Name" : defaults.valueForKey("FirebaseUsername")!, "UUID" : appDelegate.UUID, "Date": NSDate().timeIntervalSince1970, "UID": uid!]
            
            highScoresRef.childByAutoId().setValue(score1, andPriority: 0 - Int(theScore))
        
        print("posted  single score")
    }
    
    func gameLoop() {
        getHighScore()
        setHighScore()
        
        if scoresNeedResetting
        {
            currentScore = 0
            scoreLabel!.text = String(currentScore)
            scoresNeedResetting = false
        }
        
        currentNote = noteLibrary.returnRandomNote()
        createOvalNoteImage(currentNote)
        
    }
    
    func setHighScore() {
        highScoreLabel!.text = "High Score: \(highScore)"
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
            
            //ff the sound option is true, play note sound.
            if appDelegate.isSound {
                let path = NSBundle.mainBundle().pathForResource("\(note.absoluteNote)", ofType: "mp3")
                let fileUrl = NSURL(fileURLWithPath: (path)!)
                notePlayer = try? AVAudioPlayer(contentsOfURL: fileUrl)
                notePlayer.prepareToPlay()
                notePlayer.delegate = self
                notePlayer.play()
            }
            
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
        postScoreToFirebase()
        var alert = UIAlertController()
        if currentScore > highScore {
            alert = UIAlertController(title: "Game Over", message: "NEW HIGH SCORE! \n The note was :  \(currentNote.noteName.uppercaseString) \n You scored : \(currentScore)", preferredStyle: .Alert)
        }else {
            alert = UIAlertController(title: "Game Over", message: "The note was :  \(currentNote.noteName.uppercaseString) \n You scored : \(currentScore)", preferredStyle: .Alert)
        }
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
            UIView.animateWithDuration(0.3, animations: {
                sender.backgroundColor = UIColor.whiteColor()
            })
            correctGuess()
        }else {
            incorrectGuess()
            // animate a color change of the key pushed
            sender.backgroundColor = UIColor.redColor()
            UIView.animateWithDuration(0.3, animations: {
                sender.backgroundColor = UIColor.whiteColor()
            })
        }
    }
    
    
    func getHighScore() {
        if(difficulty == "easyTreble") {
            
            //get path to plist of all scores
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            plistPath = appDelegate.easyTreblePlistPathInDocument
            
            // Extract the content of the file as NSData
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
            do{
                scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
            }catch{
                print("Error occured while reading from the plist file")
            }
            
        } else if(difficulty == "easyBass") {
            
            //get path to plist of all scores
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            plistPath = appDelegate.easyBassPlistPathInDocument
            
            // Extract the content of the file as NSData
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
            do{
                scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
            }catch{
                print("Error occured while reading from the plist file")
            }
        }
            
            
        else if(difficulty == "medium") {
            
            //get path to plist of all scores
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            plistPath = appDelegate.mediumPlistPathInDocument
            
            // Extract the content of the file as NSData
            let data:NSData =  NSFileManager.defaultManager().contentsAtPath(plistPath)!
            do{
                scoresArray = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                
            }catch{
                print("Error occured while reading from the plist file")
            }
            
        }
        
        highScore = 0
        for score in scoresArray as NSArray as! [String] {
            if Int(score) > Int(highScore) {
                highScore = Int(score)!
            }
        }
    }
}


