//
//  CDMovementHelper.swift
//  WorkoutApp
//
//  Created by Nick on 11/24/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CDMovementHelper
{
  let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
  let managedObject = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

  /****************************************************************************
   *	Get muscle group for lift
   *****************************************************************************/
  func getMuscleGroupForLift(movementName: String) -> String?
  {
    var movements:[MovementsEntity] = []
    let request = NSFetchRequest(entityName: "MovementsEntity")
    let sortDesc =  NSSortDescriptor(key: "movementName", ascending: false)
    request.sortDescriptors = [sortDesc]
    let predicate = NSPredicate(format: "%K == %@", "movementName", movementName)
    request.predicate = predicate

    
    do {
      movements = try managedObject.executeFetchRequest(request) as! [MovementsEntity]
      if movements.first?.muscleGroup != nil {
        return movements.first!.muscleGroup!
      }
    } catch {
      let nserror = error as NSError
      print("Fetch error: \(nserror)")
    }

    return nil
  }
  
  
  /****************************************************************************
   *	Get all sessions
   *****************************************************************************/
  func getMovements() -> [MovementsEntity]
  {
    var movementList:[MovementsEntity] = []
    let request = NSFetchRequest(entityName: "MovementsEntity")
    let sortDesc =  NSSortDescriptor(key: "movementName", ascending: false)
    request.sortDescriptors = [sortDesc]
    
    do {
      let movements = try managedObject.executeFetchRequest(request) as! [MovementsEntity]
      movementList = movements
      print(movements)
    } catch {
      let nserror = error as NSError
      print("Fetch error: \(nserror)")
    }
    return movementList
  }
  
  
  /****************************************************************************
   *	Get all movement names
   *****************************************************************************/
  func getMovementNames() -> [String]
  {
//		var movementSet = Set<String>()
    var movementArray:[String] = []
    let request = NSFetchRequest(entityName: "MovementsEntity")
    let sortDesc =  NSSortDescriptor(key: "movementName", ascending: false)
    request.sortDescriptors = [sortDesc]
    
    do {
      let movements = try managedObject.executeFetchRequest(request) as! [MovementsEntity]
      for movement in movements {
//        movementSet.insert(movement.movementName!)
        movementArray.append(movement.movementName!)
      }
    } catch {
      let nserror = error as NSError
      print("Fetch error: \(nserror)")
    }
    movementArray.sortInPlace()
    return movementArray
  }
  
  
  
  func addMovementName(movementName: String)
  {
    let movements = getMovementNames()
    if !movements.contains(movementName) {
      let movement = NSEntityDescription.insertNewObjectForEntityForName("MovementsEntity", inManagedObjectContext: managedObject) as! MovementsEntity
      movement.movementName = movementName
      appDel.saveContext()
    }
  }
}