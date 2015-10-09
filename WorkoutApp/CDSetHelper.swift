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
    

    
    
}

