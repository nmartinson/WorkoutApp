//
//  Set+CoreDataProperties.swift
//
//
//  Created by Nick on 10/1/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SetEntity {
  
  @NSManaged var date: NSDate?
  @NSManaged var duration: NSNumber?
  @NSManaged var internalVariation: NSNumber?
  @NSManaged var maxRepTime: NSNumber?
  @NSManaged var meanRepTime: NSNumber?
  @NSManaged var minRepTime: NSNumber?
  @NSManaged var movementType: String?
  @NSManaged var repCount: NSNumber?
  @NSManaged var weight: NSNumber?
  @NSManaged var didSetPR: NSNumber?
  @NSManaged var note: String?
  @NSManaged var session: SessionEntity?
  
  var didSetPRBool: Bool? {
    get {
      return didSetPR as? Bool
    }
    set {
      didSetPR = NSNumber(bool: newValue!)
    }
  }
}
