//
//  LeaderboardItem.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-03-07.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

struct LeaderboardItem {
    
    let key: String!
    var score: Int
    let name: String!
    let ref: Firebase?
    
    
    // Initialize from arbitrary data
    init(name: String, score: Int, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.score = score

        self.ref = nil
    }
    
    init(snapshot: FDataSnapshot!) {
        key = snapshot.key!
        name = snapshot.value["Name"]! as! String!
    
        if let scoreNumber = snapshot.value["Score"] as? NSNumber?  {
            score  = scoreNumber!.integerValue
        } else {
            score = 0
        }
        ref = snapshot.ref!
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "score": score,
        ]
    }
}