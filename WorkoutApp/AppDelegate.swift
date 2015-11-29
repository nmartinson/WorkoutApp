//
//  AppDelegate.swift
//  WorkoutApp
//
//  Created by Nick on 10/1/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity
import HealthKit

extension NSDate
{
  convenience
  init(dateString:String) {
    let dateStringFormatter = NSDateFormatter()
    dateStringFormatter.dateFormat = "yyyy-MM-dd"
    dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    let d = dateStringFormatter.dateFromString(dateString)!
    self.init(timeInterval:0, sinceDate:d)
  }
}

extension AppDelegate: WCSessionDelegate
{
  /**************************************************************************
   *
   ***************************************************************************/
  func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
    
    if let sessionData = message["sessionData"] as? [String: AnyObject]
    {
      NSNotificationCenter.defaultCenter().postNotificationName("sessionData", object: nil, userInfo: sessionData)
      
    }
    else if let workoutData = message["workoutData"] as? [String: AnyObject]
    {
      NSNotificationCenter.defaultCenter().postNotificationName("workoutData", object: nil, userInfo: workoutData)
    }
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
    
    if let sessionData = userInfo["sessionData"] as? [String: AnyObject]
    {
      let workoutStartDate = sessionData["workoutStartDate"] as! NSDate
      let workoutDuration = sessionData["workoutDuration"] as! Float
      workoutSession = NSEntityDescription.insertNewObjectForEntityForName("SessionEntity", inManagedObjectContext: managedObjectContext) as? SessionEntity
      
      workoutSession?.duration = workoutDuration
      workoutSession?.date = workoutStartDate
      
    }
    else if let workoutData = userInfo["workoutData"] as? [String: AnyObject]
    {
      let movementType = workoutData["movementType"] as! String
      let repCount = workoutData["repCount"] as! Int
      let duration = workoutData["duration"] as! Float
      let meanRepTime = workoutData["meanRepTime"] as! Float
      let minRepTime = workoutData["minRepTime"] as! Float
      let maxRepTime = workoutData["maxRepTime"] as! Float
      let internalVariation = workoutData["internalVariation"] as! Float
      let lastLift = workoutData["lastLift"] as! Bool
      
      let set = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext:managedObjectContext) as! SetEntity
      set.weight = 0
      set.movementType = movementType
      set.repCount = repCount
      set.duration = duration
      set.meanRepTime = meanRepTime
      set.minRepTime = minRepTime
      set.maxRepTime = maxRepTime
      set.internalVariation = internalVariation
      set.date = NSDate()
      set.session = workoutSession
      overViewSet.insert(set.movementType!)
      workoutDataArray.append(set)
      
      if(lastLift == true){
        workoutSession?.overView = overViewSet.joinWithSeparator(",")
        saveContext()
        overViewSet.removeAll()
        workoutDataArray.removeAll()
        workoutSession = nil
      }
    }
    
    
//    print("GOT USER DATA")
//    print(userInfo)
//    if let sessionData = userInfo["sessionData"] as? [String: AnyObject]
//    {
//      NSNotificationCenter.defaultCenter().postNotificationName("sessionData", object: nil, userInfo: sessionData)
//      
//    }
//    else if let workoutData = userInfo["workoutData"] as? [String: AnyObject]
//    {
//      NSNotificationCenter.defaultCenter().postNotificationName("workoutData", object: nil, userInfo: workoutData)
//    }
    
  }
  
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let healthStore = HKHealthStore()
  var overViewSet = Set<String>()
  var workoutDataArray:[SetEntity] = []
  var workoutSession:SessionEntity?
  //    var session: WCSession? {
  //        didSet {
  //            if let session = session {
  //                session.delegate = self
  //                session.activateSession()
  //            }
  //        }
  //    }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    //        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().barTintColor = BAR_TINT_COLOR
    
    if WCSession.isSupported() {
      WCSession.defaultSession().delegate = self
      WCSession.defaultSession().activateSession()
    }
//    populateWithTestData()
    return true
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
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
  func applicationShouldRequestHealthAuthorization(application: UIApplication) {
    
    guard HKHealthStore.isHealthDataAvailable() else {
      return
    }
    
    self.healthStore.handleAuthorizationForExtensionWithCompletion { (_, error) -> Void in
      print(error)
    }
  }
  // MARK: - Core Data stack
  
  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.BAApps.WorkoutApp" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = NSBundle.mainBundle().URLForResource("WorkoutApp", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
  
  
  
  func populateWithTestData()
  {
    var overViewSet = Set<String>()
    let session = NSEntityDescription.insertNewObjectForEntityForName("SessionEntity", inManagedObjectContext: managedObjectContext) as! SessionEntity
    session.duration = 3600
    session.date = NSDate(dateString:"2015-09-06")
    
    let set1 = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set1.duration = 45
    set1.internalVariation = 3.5
    set1.maxRepTime = 5
    set1.minRepTime = 2
    set1.meanRepTime = 3
    set1.movementType = "Push Press"
    set1.weight = 145
    set1.repCount = 10
    set1.date = session.date?.dateByAddingTimeInterval(10)
    set1.session = session
    overViewSet.insert(set1.movementType!)
    set1.session = session
    
    
    let set2 = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set2.duration = 45
    set2.internalVariation = 3.5
    set2.maxRepTime = 5
    set2.minRepTime = 2
    set2.meanRepTime = 3
    set2.movementType = "Push Press"
    set2.weight = 170
    set2.repCount = 8
    set2.date = set1.date?.dateByAddingTimeInterval(45)
    set2.session = session
    overViewSet.insert(set2.movementType!)
    set2.session = session
    
    
    let set3 = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set3.duration = 45
    set3.internalVariation = 3.5
    set3.maxRepTime = 5
    set3.minRepTime = 2
    set3.meanRepTime = 3
    set3.movementType = "Push Press"
    set3.weight = 200
    set3.repCount = 6
    set3.date = set2.date?.dateByAddingTimeInterval(45)
    set3.session = session
    overViewSet.insert(set3.movementType!)
    set3.session = session
    
    
    let set11 = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set11.duration = 45
    set11.internalVariation = 3.5
    set11.maxRepTime = 5
    set11.minRepTime = 2
    set11.meanRepTime = 3
    set11.movementType = "Dumbbell Flies"
    set11.weight = 30
    set11.repCount = 8
    set11.date = set3.date?.dateByAddingTimeInterval(45)
    set11.session = session
    overViewSet.insert(set11.movementType!)
    set11.session = session
    
    
    let set12 = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set12.duration = 45
    set12.internalVariation = 3.5
    set12.maxRepTime = 5
    set12.minRepTime = 2
    set12.meanRepTime = 3
    set12.movementType = "Dumbbell Flies"
    set12.weight = 35
    set12.repCount = 8
    set12.date = set11.date?.dateByAddingTimeInterval(45)
    set12.session = session
    overViewSet.insert(set12.movementType!)
    set12.session = session
    
    
    let set13 = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set13.duration = 45
    set13.internalVariation = 3.5
    set13.maxRepTime = 5
    set13.minRepTime = 2
    set13.meanRepTime = 3
    set13.movementType = "Dumbbell Flies"
    set13.weight = 40
    set13.repCount = 6
    set13.date = set12.date?.dateByAddingTimeInterval(45)
    set13.session = session
    overViewSet.insert(set13.movementType!)
    set13.session = session
    session.overView = overViewSet.joinWithSeparator(",")
    
    
    
    var overview2 = Set<String>()
    let session2 = NSEntityDescription.insertNewObjectForEntityForName("SessionEntity", inManagedObjectContext: managedObjectContext) as! SessionEntity
    session2.duration = 3600
    session2.date = NSDate(dateString:"2015-09-10")
    //        session.sets =
    
    let set1s = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set1s.duration = 45
    set1s.internalVariation = 3.5
    set1s.maxRepTime = 5
    set1s.minRepTime = 2
    set1s.meanRepTime = 3
    set1s.movementType = "Bench Press"
    set1s.weight = 145
    set1s.repCount = 10
    set1s.date = session2.date?.dateByAddingTimeInterval(10)
    set1s.session = session2
    overview2.insert(set1s.movementType!)
    set1s.session = session2
    
    
    let set2s = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set2s.duration = 45
    set2s.internalVariation = 3.5
    set2s.maxRepTime = 5
    set2s.minRepTime = 2
    set2s.meanRepTime = 3
    set2s.movementType = "Bench Press"
    set2s.weight = 170
    set2s.repCount = 8
    set2s.date = set1s.date?.dateByAddingTimeInterval(45)
    set2s.session = session2
    overview2.insert(set2s.movementType!)
    set2s.session = session2
    
    let set3s = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set3s.duration = 45
    set3s.internalVariation = 3.5
    set3s.maxRepTime = 5
    set3s.minRepTime = 2
    set3s.meanRepTime = 3
    set3s.movementType = "Bench Press"
    set3s.weight = 200
    set3s.repCount = 6
    set3s.date = set2s.date?.dateByAddingTimeInterval(45)
    set3s.session = session2
    overview2.insert(set3s.movementType!)
    set3s.session = session2
    
    let set11s = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set11s.duration = 45
    set11s.internalVariation = 3.5
    set11s.maxRepTime = 5
    set11s.minRepTime = 2
    set11s.meanRepTime = 3
    set11s.movementType = "Dumbbell Flies"
    set11s.weight = 30
    set11s.repCount = 8
    set11s.date = set3s.date?.dateByAddingTimeInterval(45)
    set11s.session = session2
    overview2.insert(set11s.movementType!)
    set11s.session = session2
    
    let set12s = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set12s.duration = 45
    set12s.internalVariation = 3.5
    set12s.maxRepTime = 5
    set12s.minRepTime = 2
    set12s.meanRepTime = 3
    set12s.movementType = "Dumbbell Flies"
    set12s.weight = 35
    set12s.repCount = 8
    set12s.date = set11s.date?.dateByAddingTimeInterval(45)
    set12s.session = session
    overview2.insert(set12s.movementType!)
    set12s.session = session2
    
    let set13s = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: managedObjectContext) as! SetEntity
    set13s.duration = 45
    set13s.internalVariation = 3.5
    set13s.maxRepTime = 5
    set13s.minRepTime = 2
    set13s.meanRepTime = 3
    set13s.movementType = "Dumbbell Flies"
    set13s.weight = 40
    set13s.repCount = 6
    set13s.date = set12s.date?.dateByAddingTimeInterval(45)
    set13s.session = session2
    overview2.insert(set13s.movementType!)
    set13s.session = session2
    session2.overView = overview2.joinWithSeparator(",")
    
    self.saveContext()
  }
  
}

