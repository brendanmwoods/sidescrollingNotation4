//
//  NoteLibrary.swift
//  NotationApp_v1
//
//  Created by brendan woods on 2016-01-24.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import Foundation

class NoteLibrary:NSObject {
    
    //Difficulty constants
    let easyTrebleBottomNote = 40
    let easyTrebleTopNote = 57
    let easyBassBottomNote = 23
    let easyBassTopNote = 40
    let mediumBottomNote = 23
    let mediumTopNote = 57
    var includeFlatsAndSharps = false
    var bottomNoteDiffFromTop = 32
    
    var totalNotes = 88
    var allNotesArr = [(noteName: String,octaveNumber: Int,
        absoluteNote: Int, isFlatOrSharp:Bool, diffFromTop:Int)]()
    var previousNoteAbsoluteNote = 0
    
    func fillNoteLibrary() {
        
        //create all 88 notes and assign absolute note number
        for (var i = 1; i <= totalNotes ; i++) {
            var tempNote = (noteName:"",octaveNumber:0,absoluteNote:0,false,diffFromTop:0)
            tempNote.absoluteNote = i
            allNotesArr.append(tempNote)
        }
        
        //assign octave numbers to all 88 notes in array
        for note in 0..<totalNotes {
            switch allNotesArr[note].absoluteNote {
            case 1...3: allNotesArr[note].octaveNumber = 0
            case 4...15: allNotesArr[note].octaveNumber = 1
            case 16...27: allNotesArr[note].octaveNumber = 2
            case 28...39: allNotesArr[note].octaveNumber = 3
            case 40...51: allNotesArr[note].octaveNumber = 4
            case 52...63: allNotesArr[note].octaveNumber = 5
            case 64...75: allNotesArr[note].octaveNumber = 6
            case 76...87: allNotesArr[note].octaveNumber = 7
            case 88: allNotesArr[note].octaveNumber = 8
            default: ("default case shouldn't be reached")
            }
        }
        
        
        //assign note names to all 88 notes
        for index in 0..<totalNotes {
            switch allNotesArr[index].absoluteNote % 12 {
            case 0 : allNotesArr[index].noteName = "ab"
            allNotesArr[index].isFlatOrSharp = true
            case 1 : allNotesArr[index].noteName = "a"
            case 2 : allNotesArr[index].noteName = "bb"
            allNotesArr[index].isFlatOrSharp = true
            case 3 : allNotesArr[index].noteName = "b"
            case 4 : allNotesArr[index].noteName = "c"
            case 5 : allNotesArr[index].noteName = "db"
            allNotesArr[index].isFlatOrSharp = true
            case 6 : allNotesArr[index].noteName = "d"
            case 7 : allNotesArr[index].noteName = "eb"
            allNotesArr[index].isFlatOrSharp = true
            case 8 : allNotesArr[index].noteName = "e"
            case 9 : allNotesArr[index].noteName = "f"
            case 10 : allNotesArr[index].noteName = "gb"
            allNotesArr[index].isFlatOrSharp = true
            case 11 : allNotesArr[index].noteName = "g"
            default : print("default case shouldn't be reached")
            }
        }
        
        
        //assign diffFromTop units for each non flat/sharp note
        //used for plotting notes on the grand staff.
        var tempDiffFromTop = bottomNoteDiffFromTop
        
        for index in 0..<totalNotes{
            if allNotesArr[index].isFlatOrSharp == false {
                allNotesArr[index].diffFromTop = tempDiffFromTop
                tempDiffFromTop--
            }
        }
    }
    
    
    //set the filter paramters for difficulty top and bottom note
    //and filter out all notes out of that range. finally, remove
    //all flats and sharps unless the boolean says otherwise
    func filterNotesForDifficulty(difficulty:String) {
        var tempBottomNote = 0
        var tempTopNote = 0
        
        switch difficulty {
        case "easyTreble":
            tempBottomNote = easyTrebleBottomNote
            tempTopNote = easyTrebleTopNote
        case "easyBass":
            tempBottomNote = easyBassBottomNote
            tempTopNote = easyBassTopNote
        case "medium":
            tempBottomNote = mediumBottomNote
            tempTopNote = mediumTopNote
        default:
            print("default case for filtering based on difficulty")
        }
        
        for var i = allNotesArr.count-1; i >= 0; i-- {
            if allNotesArr[i].absoluteNote < tempBottomNote ||
                allNotesArr[i].absoluteNote > tempTopNote  {
                    allNotesArr.removeAtIndex(i)
            }
        }
        
        // remove flats and sharps unless the boolean changed
        if !includeFlatsAndSharps {
            removeFlatsAndSharps()
        }
    }
    
    
    //remove all the flat and sharp notes
    func removeFlatsAndSharps() {
        for var i = allNotesArr.count-1; i >= 0; i-- {
            if allNotesArr[i].isFlatOrSharp == true {
                allNotesArr.removeAtIndex(i)
            }
        }
    }
    
    
    //return the note array
    func returnNotesArray() -> [(noteName: String,octaveNumber: Int,
        absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int)] {
            return allNotesArr
    }
    
    
    //print every note in the allNotesArr
    func printAllNotes() {
        print("Array currently contains \(allNotesArr.count) notes")
        for note in allNotesArr {
            print(note)
        }
    }
    
    //return random note from allNotesArr. make sure it doesn't repeat 
    func returnRandomNote() -> ((noteName: String,octaveNumber: Int,
        absoluteNote: Int, isFlatOrSharp:Bool,diffFromTop:Int)) {
            
        let total = allNotesArr.count
        var noteInt = Int(arc4random_uniform(UInt32(total)))
        var newNote =  allNotesArr[noteInt]
            while newNote.absoluteNote == previousNoteAbsoluteNote  {
                noteInt = Int(arc4random_uniform(UInt32(total)))
                newNote =  allNotesArr[noteInt]
            }
        previousNoteAbsoluteNote = newNote.absoluteNote
        return newNote
    }
}

// Current note info below
/*
("a", 0, 1, false, 0)
("bb", 0, 2, true, 0)
("b", 0, 3, false, 0)
("c", 1, 4, false, 0)
("db", 1, 5, true, 0)
("d", 1, 6, false, 0)
("eb", 1, 7, true, 0)
("e", 1, 8, false, 0)
("f", 1, 9, false, 0)
("gb", 1, 10, true, 0)
("g", 1, 11, false, 0)
("ab", 1, 12, true, 0)
("a", 1, 13, false, 0)
("bb", 1, 14, true, 0)
("b", 1, 15, false, 0)
("c", 2, 16, false, 0)
("db", 2, 17, true, 0)
("d", 2, 18, false, 0)
("eb", 2, 19, true, 0)
("e", 2, 20, false, 0)
("f", 2, 21, false, 0)
("gb", 2, 22, true, 0)
("g", 2, 23, false, 0)
("ab", 2, 24, true, 0)
("a", 2, 25, false, 0)
("bb", 2, 26, true, 0)
("b", 2, 27, false, 0)
("c", 3, 28, false, 0)
("db", 3, 29, true, 0)
("d", 3, 30, false, 0)
("eb", 3, 31, true, 0)
("e", 3, 32, false, 0)
("f", 3, 33, false, 0)
("gb", 3, 34, true, 0)
("g", 3, 35, false, 0)
("ab", 3, 36, true, 0)
("a", 3, 37, false, 0)
("bb", 3, 38, true, 0)
("b", 3, 39, false, 0)
("c", 4, 40, false, 0)
("db", 4, 41, true, 0)
("d", 4, 42, false, 0)
("eb", 4, 43, true, 0)
("e", 4, 44, false, 0)
("f", 4, 45, false, 0)
("gb", 4, 46, true, 0)
("g", 4, 47, false, 0)
("ab", 4, 48, true, 0)
("a", 4, 49, false, 0)
("bb", 4, 50, true, 0)
("b", 4, 51, false, 0)
("c", 5, 52, false, 0)
("db", 5, 53, true, 0)
("d", 5, 54, false, 0)
("eb", 5, 55, true, 0)
("e", 5, 56, false, 0)
("f", 5, 57, false, 0)
("gb", 5, 58, true, 0)
("g", 5, 59, false, 0)
("ab", 5, 60, true, 0)
("a", 5, 61, false, 0)
("bb", 5, 62, true, 0)
("b", 5, 63, false, 0)
("c", 6, 64, false, 0)
("db", 6, 65, true, 0)
("d", 6, 66, false, 0)
("eb", 6, 67, true, 0)
("e", 6, 68, false, 0)
("f", 6, 69, false, 0)
("gb", 6, 70, true, 0)
("g", 6, 71, false, 0)
("ab", 6, 72, true, 0)
("a", 6, 73, false, 0)
("bb", 6, 74, true, 0)
("b", 6, 75, false, 0)
("c", 7, 76, false, 0)
("db", 7, 77, true, 0)
("d", 7, 78, false, 0)
("eb", 7, 79, true, 0)
("e", 7, 80, false, 0)
("f", 7, 81, false, 0)
("gb", 7, 82, true, 0)
("g", 7, 83, false, 0)
("ab", 7, 84, true, 0)
("a", 7, 85, false, 0)
("bb", 7, 86, true, 0)
("b", 7, 87, false, 0)
("c", 8, 88, false, 0)
*/