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
  let managedObject = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

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
  
  func saveMovements()
  {
    let set1 = NSEntityDescription.insertNewObjectForEntityForName("MovementsEntity", inManagedObjectContext: managedObject) as! MovementsEntity

  }
}