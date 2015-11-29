//
//  Movements+CoreDataProperties.swift
//  WorkoutApp
//
//  Created by Nick on 11/24/15.
//  Copyright © 2015 Nick. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MovementsEntity {

    @NSManaged var movementName: String?
    @NSManaged var isFocusMotionDefault: NSNumber?
    @NSManaged var isAppDefault: NSNumber?

}
