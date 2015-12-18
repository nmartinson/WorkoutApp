//
//  Session+CoreDataProperties.swift
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

extension SessionEntity {
  
  @NSManaged var date: NSDate?
  @NSManaged var duration: NSNumber?
  @NSManaged var overView: String?
  @NSManaged var sets: NSSet?
  @NSManaged var note:String?
}
