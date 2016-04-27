//
//  LearningViewController.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-17.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit
import AVFoundation

class LearningViewController: UIViewController, AVAudioPlayerDelegate   {
    
    @IBOutlet weak var blankStaff: UIView?
    @IBOutlet weak var aButton:UIButton?
    @IBOutlet weak var bButton:UIButton?
    @IBOutlet weak var cButton:UIButton?
    @IBOutlet weak var dButton:UIButton?
    @IBOutlet weak var eButton:UIButton?
    @IBOutlet weak var fButton:UIButton?
    @IBOutlet weak var gButton:UIButton?
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var noteLabel:UILabel!
    @IBOutlet weak var grandStaffView:UIImageView!
    
    var ovalNoteImageView = UIImageView()
    var noteImageView = UIImageView()
    
    let topLineY:CGFloat = 100
    var screenWidth:CGFloat = 0
    let ovalNoteWidth:CGFloat = 30
    let ovalNoteHeight:CGFloat = 20
    var noteImageHeight:CGFloat = 0
    var noteImageWidth:CGFloat = 0
    
    let spaceBetweenNotes:CGFloat = 10
    var noteLibrary = NoteLibrary()
    var currentNote: (noteName: String,octaveNumber: Int,
        absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int) = ("",0,0,false,0)
    var totalCorrect = 0
    var totalIncorrect = 0
    var difficulty = ""
    var notePlayer : AVAudioPlayer! = nil
    var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let imageName = "ovalNote.png"
        let image = UIImage(named: imageName)
        ovalNoteImageView = UIImageView(image: image!)
        
        noteImageView.removeFromSuperview()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        noteImageView.removeFromSuperview()
        noteImageHeight = grandStaffView.frame.size.height
        noteImageWidth = noteImageHeight/8.333
        
        noteLabel.hidden = true
        currentNote = noteLibrary.returnRandomNote()
        
        createNoteImage(currentNote)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        blankStaff?.setNeedsDisplay()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        screenWidth = UIScreen.mainScreen().bounds.width
        formatButtonShapes()
        noteLibrary = NoteLibrary()
        difficulty = appDelegate.practiceModeDifficulty
        noteLibrary.fillNoteLibrary()
        
        noteLibrary.filterNotesForDifficulty(difficulty)
        
        gameLoop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func gameLoop() {
        
        noteLabel.hidden = true
        currentNote = noteLibrary.returnRandomNote()
        
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
    
    func createNoteImage(note: (noteName: String,octaveNumber: Int,
        absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int)) {
        //need navigation bar and status height to compensate for positioning of note
        let navHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)!
        
        let statusHeight:CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let imageName = "\(note.absoluteNote).png"
        let image = UIImage(named: imageName)
        noteImageView = UIImageView(image: image!)
        
        noteImageView.frame = CGRectMake(
            (screenWidth/2) - (noteImageWidth/2),
            grandStaffView.frame.origin.y + navHeight + statusHeight,
            noteImageWidth,
            noteImageHeight)
        view.addSubview(noteImageView)
        
        //if the sound option is true, play the note sound.
        if appDelegate.isSound {
            let path = NSBundle.mainBundle().pathForResource("\(note.absoluteNote)", ofType: "mp3")
            let fileUrl = NSURL(fileURLWithPath: (path)!)
            notePlayer = try? AVAudioPlayer(contentsOfURL: fileUrl)
            notePlayer.prepareToPlay()
            notePlayer.delegate = self
            notePlayer.play()
        }
    }
    
    
    
    func correctGuess() {
        totalCorrect += 1
        updateResultsLabel()
        gameLoop()
        noteImageView.removeFromSuperview()
        createNoteImage(currentNote)
    }
    
    func incorrectGuess() {
        totalIncorrect += 1
        updateResultsLabel()
    }
    
    func updateResultsLabel() {
        scoreLabel!.text = String("\(totalCorrect) / \(totalCorrect + totalIncorrect)")
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
            // animate a color change of the key pushed
            sender.backgroundColor = UIColor.redColor()
            UIView.animateWithDuration(0.3, animations: {
                sender.backgroundColor = UIColor.whiteColor()
            })
            incorrectGuess()
        }
        
    }
    
    @IBAction func showNotePushed(sender:UIButton) {
        noteLabel.text = "\(currentNote.noteName.uppercaseString)"
        noteLabel.hidden = false
    }
}