//
//  AppDelegate.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-10.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //the app option for sound
    var isSound = true
    
    //this will be the path for our plist, and will be accessable from
    //everywhere in the app.
    var easyTreblePlistPathInDocument:String = String()
    var easyBassPlistPathInDocument:String = String()
    var mediumPlistPathInDocument:String = String()
    var UUID = String()
    var UID = String()
    var window: UIWindow?
    var username = String()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        preparePlistsForUse()
        setUUID()
        setUsername()
        return true
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
        if(userDefaults.objectForKey("Username") != nil) {
            username = String(userDefaults.objectForKey("Username")!)
        }
    }
    
    func clearLocalUsername() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("Username")
    }
    
    func preparePlistsForUse(){
        // Get a path to the documents directory
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        
        // make a path to the docs folder for the scores.plist
        // Check if a file already exists at that docs path
        // if it doesnot, get a path to the main bundle version
        easyTreblePlistPathInDocument = rootPath.stringByAppendingString("/easyTrebleScores.plist")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(easyTreblePlistPathInDocument){
            let plistPathInBundle = NSBundle.mainBundle().pathForResource("easyTrebleScores", ofType: "plist") as String!
            // if the docs path(file) doesn't exist, copy the item to documents path
            // from the main bundle
            do {
                try NSFileManager.defaultManager().copyItemAtPath(plistPathInBundle, toPath: easyTreblePlistPathInDocument)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
        
        easyBassPlistPathInDocument = rootPath.stringByAppendingString("/easyBassScores.plist")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(easyBassPlistPathInDocument){
            let plistPathInBundle = NSBundle.mainBundle().pathForResource("easyBassScores", ofType: "plist") as String!
            // if the docs path(file) doesn't exist, copy the item to documents path
            // from the main bundle
            do {
                try NSFileManager.defaultManager().copyItemAtPath(plistPathInBundle, toPath: easyBassPlistPathInDocument)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
        
        mediumPlistPathInDocument = rootPath.stringByAppendingString("/mediumScores.plist")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(mediumPlistPathInDocument){
            let plistPathInBundle = NSBundle.mainBundle().pathForResource("mediumScores", ofType: "plist") as String!
            // if the docs path(file) doesn't exist, copy the item to documents path
            // from the main bundle
            do {
                try NSFileManager.defaultManager().copyItemAtPath(plistPathInBundle, toPath: mediumPlistPathInDocument)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
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
        self.preparePlistsForUse()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

