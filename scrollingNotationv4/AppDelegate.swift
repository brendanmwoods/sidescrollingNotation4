//
//  AppDelegate.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-10.
//  Copyright © 2016 brendan woods. All rights reserved.
//


import UIKit
import Firebase
//import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var isSound = true
    var UUID = String()
    var UID = String()
    var window: UIWindow?
    var username = String()
    var allPlayerScores = [Int]()
    var highScore = 0
    var practiceModeDifficulty = "medium"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        registerForPushNotifications(application)
        setUUID()
        setUsername()
        getPlayerScores()
        setIsSound()
        return true
    }
    
    func setIsSound() {
        let defaults = NSUserDefaults()
        
        if defaults.valueForKey("isSound") != nil {
        isSound = defaults.valueForKey("isSound") as! Bool
        }
        print(isSound)
    }
    
    func getPlayerScores() {
        let defaults = NSUserDefaults()
        if defaults.valueForKey("FirebaseUID") != nil {
            let scoresRef = Firebase(url: "https://glowing-torch-8861.firebaseio.com/High%20Scores")
            scoresRef.queryOrderedByChild("UID").queryEqualToValue(defaults.valueForKey("FirebaseUID")).observeEventType(.ChildAdded, withBlock: {
                snapshot in
                let score:Int = snapshot.value["Score"] as! Int
                self.allPlayerScores.append(score)
                if score > self.highScore {
                    self.highScore = score
                }
            })
        }
    }
    
    func setUUID() {
        //if uuid has been set, assign to delegate. otherwise create one
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.objectForKey("ApplicationUniqueIdentifier") == nil {
            let tempUUID = NSUUID().UUIDString
            UUID = tempUUID
            userDefaults.setObject(tempUUID, forKey: "ApplicationUniqueIdentifier")
            userDefaults.synchronize()
        } else {
            UUID = String(userDefaults.objectForKey("ApplicationUniqueIdentifier")!)
        }
    }
    
    //if a username has been set to userdefaults before, assign to delegate variable
    func setUsername() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("FirebaseUsername") != nil) {
            username = String(userDefaults.objectForKey("FirebaseUsername")!)
        }
    }
    
    func clearLocalUsername() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("Username")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        let defaults = NSUserDefaults()
        defaults.setValue(tokenString, forKey: "token")
        
        //if we are logged in when notifications are accepted, send the token to firebase
        if (defaults.objectForKey("FirebaseUsername") != nil) {
            let tokenRef = Firebase(url:"https://glowing-torch-8861.firebaseio.com/Usernames/\(defaults.valueForKey("FirebaseUsername")!)")
            tokenRef.updateChildValues(["token" : defaults.valueForKey("token")!])
        }
        
        print("Device Token:", tokenString)
        
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
}

