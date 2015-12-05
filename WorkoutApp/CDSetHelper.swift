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

      self.appDel.saveContext()
    })

  }
  
  func deleteLift(session: SessionEntity, set: SetEntity) {
		managedObject.deleteObject(set)
    session.overView = session.overView?.stringByReplacingOccurrencesOfString(set.movementType!, withString: "")
    appDel.saveContext()
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
  func printSets()
  {
    let request = NSFetchRequest(entityName: "SetEntity")
    let sortDesc =  NSSortDescriptor(key: "movementType", ascending: true)
    request.sortDescriptors = [sortDesc]
    
    do {
      let results = try managedObject.executeFetchRequest(request) as! [SetEntity]
      for result:SetEntity in results
      {
        print("lift: \(result.movementType)     reps: \(result.repCount!)    weight: \(result.weight!)     date: \(result.date)")
      }
    } catch {
      let nserror = error as NSError
      print("Fetch error: \(nserror)")
    }
  }
  
  
  /****************************************************************************
   *
   *****************************************************************************/
  func updateSet(set: SetEntity)
  {
    let objectID = set.objectID
    managedObject.objectWithID(objectID)
    
    do {
      var object = try managedObject.existingObjectWithID(objectID) as! SetEntity
      object = set
      appDel.saveContext()
      
    } catch {
      let nserror = error as NSError
      print("Error finding object by ID \(nserror)")
    }
  }
  
  
  
  
  
  
  
}

