//
//  CDSetHelper.swift
//  WorkoutApp
//
//  Created by Nick on 10/2/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class CDSetHelper
{
  let managedObject = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
  
  
  func resetContext(){
    managedObject.reset()
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func addTemporarySet(weight: Double, repCount: Int, movement: String) -> SetEntity{
    
    let set = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext:self.managedObject) as! SetEntity
    set.weight = weight
    set.movementType = movement
    set.repCount = repCount
    set.duration = nil
    set.meanRepTime = nil
    set.minRepTime = nil
    set.maxRepTime = nil
    set.internalVariation = nil
    set.date = NSDate()
    managedObject.undo()
    return set
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func addSet(session:SessionEntity, weight: NSNumber, repCount: NSNumber, movement: String) {
    managedObject.performBlockAndWait({ () -> Void in
      
      let (_, weightPR) = self.getPRforLift(movement)
      
      // check if it is a new lift. if so, add lift to overView
      if session.overView == nil {
        session.overView = movement
      } else if !session.overView!.containsString(movement) {
        session.overView = session.overView! + "," + movement
        session.overView = session.overView?.stringByReplacingOccurrencesOfString(",,", withString: ",")
      }
      
      let set = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext:self.managedObject) as! SetEntity
      set.weight = weight
      set.movementType = movement
      set.repCount = repCount
      set.duration = nil
      set.meanRepTime = nil
      set.minRepTime = nil
      set.maxRepTime = nil
      set.internalVariation = nil
      set.date = NSDate()
      set.session = session
      
      if Double(weight) > weightPR {
        set.didSetPRBool = true
      } else {
        set.didSetPRBool = false
      }
      
      print("didSetPRBool \(set.didSetPRBool)")
      
      self.appDel.saveContext()
    })
    
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func deleteLift(session: SessionEntity, set: SetEntity) {
    managedObject.deleteObject(set)
    session.overView = session.overView?.stringByReplacingOccurrencesOfString(set.movementType!, withString: "")
    appDel.saveContext()
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func deleteSets(sets: [SetEntity], session:SessionEntity, deleteFromOverView:Bool) -> Bool{
    var didDeleteSession = false
    if deleteFromOverView {
      let movement = sets.first!.movementType!
      session.overView = session.overView?.stringByReplacingOccurrencesOfString(movement,
        withString: "")
      if session.overView!.isEmpty {
        CDSessionHelper().deleteSession(session)
        didDeleteSession = true
      }
    }
    for set in sets {
      managedObject.deleteObject(set)
    }

    appDel.saveContext()
    return didDeleteSession
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func deleteSetTemporary(set: SetEntity) {
    managedObject.deleteObject(set)
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func getPRforLift(movement: String) -> (Int, Double)
  {
    var results:[SetEntity]?
    let request = NSFetchRequest(entityName: "SetEntity")
    let sortDesc =  NSSortDescriptor(key: "weight", ascending: false)
    let predicate = NSPredicate(format: "%K == %@", "movementType", movement)
    request.predicate = predicate
    
    request.sortDescriptors = [sortDesc]
    
    do {
      results = try managedObject.executeFetchRequest(request) as! [SetEntity]
    } catch {
      let nserror = error as NSError
      print("Fetch error: \(nserror)")
    }
    return (results![0].repCount! as Int, results![0].weight! as Double)
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func getDataForOverviewPieChart()
  {
    let request = NSFetchRequest(entityName: "SessionEntity")
    let sortDesc =  NSSortDescriptor(key: "overView", ascending: true)
    request.sortDescriptors = [sortDesc]
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func getSets() -> [AnyObject]?
  {
    var results:[AnyObject]?
    let request = NSFetchRequest(entityName: "SetEntity")
    let sortDesc =  NSSortDescriptor(key: "movementType", ascending: true)
    request.sortDescriptors = [sortDesc]
    
    do {
      results = try managedObject.executeFetchRequest(request)
    } catch {
      let nserror = error as NSError
      print("Fetch error: \(nserror)")
    }
    return results
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func updateSet(set: SetEntity, weight:Double, repCount: Int)
  {
    set.weight = weight
    set.repCount = repCount
    appDel.saveContext()
  }
  
  func undoChanges() {
    managedObject.undo()
  }
  
  func saveChanges() {
    appDel.saveContext()
  }
}

