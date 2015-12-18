//
//  ExtensionDelegate.swift
//  WorkoutWatch Extension
//
//  Created by Nick on 10/7/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import WatchKit


public func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        if(background != nil){ background!(); }
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            if(completion != nil){ completion!(); }
        }
    }
}

extension ExtensionDelegate: WCSessionDelegate
{
    func sessionReachabilityDidChange(session: WCSession) {
        print("REACHABILITY CHANGED")
        if (WCSession.defaultSession().reachable)
        {
            print("REACHABLE")
        } else {
            print("NOT REACHABLE")
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("RECEIVED MESSAGE")
        if let trainData = message["trainData"] as? [String: AnyObject]
        {
            let repCount = trainData["repCount"] as? Int
            let movementType = trainData["movementType"] as? String
            
            NSNotificationCenter.defaultCenter().postNotificationName("trainData", object: nil, userInfo: trainData)
        }
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate
{
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        var config = FmConfig()
        FmConfigInit(&config)
        
        FmInit(&config, "34DNjw?K0jjhds8rfD4JwhbJXI7PFKCo")
        FmLocalDevice.initializeInstance()
        
        if WCSession.isSupported() {
			WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
        }
        if (WCSession.defaultSession().reachable)
        {
            print("REACHABLE")
        } else {
            print("NOT REACHABLE")
        }
    }
    


    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    


    
}
