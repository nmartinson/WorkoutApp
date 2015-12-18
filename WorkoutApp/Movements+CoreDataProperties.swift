//
//  Movements+CoreDataProperties.swift
//  WorkoutApp
//
//  Created by Nick on 12/6/15.
//  Copyright © 2015 Nick. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MovementsEntity {
  
  @NSManaged var isAppDefault: NSNumber?
  @NSManaged var isFocusMotionDefault: NSNumber?
  @NSManaged var movementName: String?
  @NSManaged var movementGuide: String?
  @NSManaged var primaryMuscle: String?
  @NSManaged var secondaryMuscle: String?
  @NSManaged var startImage: String?
  @NSManaged var endImage: String?
  @NSManaged var type: String?
  @NSManaged var muscleGroup: String?
  
}
