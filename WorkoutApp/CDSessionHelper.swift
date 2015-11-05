//
//  CDSessionHelper.swift
//  WorkoutApp
//
//  Created by Nick on 10/3/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CDSessionHelper
{
    let managedObject = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    /****************************************************************************
    *
    *****************************************************************************/
    func printSession()
    {
        let request = NSFetchRequest(entityName: "SessionEntity")
        let sortDesc =  NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDesc]
        
        do {
            let results = try managedObject.executeFetchRequest(request) as! [SessionEntity]
            for result:SessionEntity in results
            {
                print("date: \(result.date)     duration: \(result.duration)    overview: \(result.overView)")
            }
        } catch {
            let nserror = error as NSError
            print("Fetch error: \(nserror)")
        }
    }
    
    /****************************************************************************
    *	Get all sessions
    *****************************************************************************/
    func getSessions() -> [SessionEntity]
    {
        var sessionList:[SessionEntity] = []
        let request = NSFetchRequest(entityName: "SessionEntity")
        let sortDesc =  NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDesc]
        
        do {
            let sessions = try managedObject.executeFetchRequest(request) as! [SessionEntity]
            sessionList = sessions
        } catch {
            let nserror = error as NSError
            print("Fetch error: \(nserror)")
        }
        return sessionList
    }
    
    /****************************************************************************
    *	
    *****************************************************************************/
    func getLiftStats(lift: String) -> [[SetEntity]]?
    {
        var liftsBySet:[[SetEntity]]? = []
		let arr = Array<SetEntity>()

        let request = NSFetchRequest(entityName: "SessionEntity")
        let sortDesc =  NSSortDescriptor(key: "date", ascending: true)
        let predicate = NSPredicate(format: "%K == %@", "movementType", lift)
        request.sortDescriptors = [sortDesc]
        
        do {
            let sessions = try managedObject.executeFetchRequest(request) as! [SessionEntity]
            for session:SessionEntity in sessions
            {
                if session.overView!.containsString(lift)
                {
                    let filteredLift = session.sets!.filteredSetUsingPredicate(predicate) as! Set<SetEntity>
                    liftsBySet?.append(Array(filteredLift))
                }
            }
            return liftsBySet
        } catch {
            let nserror = error as NSError
            print("Fetch error: \(nserror)")
        }
        return nil
    }
    
    
    /****************************************************************************
    *	Get a single session
    *****************************************************************************/
    func getSession(sessionId: NSManagedObjectID) -> (SessionEntity?,[[SetEntity]]?)
    {
        do{
            var setsArray:[[SetEntity]]? = []
            let session = try managedObject.existingObjectWithID(sessionId) as! SessionEntity
            
            let overViewArr = session.overView!.characters.split{$0 == ","}.map(String.init)
            for lift:String in overViewArr
            {
                let predicate = NSPredicate(format: "%K == %@", "movementType", lift)
				let liftArray = (session.sets?.filteredSetUsingPredicate(predicate) as! Set<SetEntity>)
                let arr = Array(liftArray)
				setsArray!.append(arr)
            }

            return (session, setsArray)
        }catch
        {
            let nserror = error as NSError
            print("Existing Object error \(nserror)")
        }
        return (nil, nil)
    }
    
    
    /****************************************************************************
    *	Gets the frequency of each lift 
    *	return:	dictionary<String,Int> of lift, # of occurences & sum of lifts
    *****************************************************************************/
    func getLiftFrequency() -> (Dictionary<String,Int>?, Int)
    {
		var liftDictionary = Dictionary<String,Int>()
        var sum = 0
        let request = NSFetchRequest(entityName: "SessionEntity")
        
        do {
            let results = try managedObject.executeFetchRequest(request) as! [SessionEntity]
            for result:SessionEntity in results
            {
                let overViewArr = result.overView!.characters.split{$0 == ","}.map(String.init)
                for lift:String in overViewArr
                {
                    if let val = liftDictionary[lift] {
                        liftDictionary[lift] = val + 1
                    } else {
                        liftDictionary[lift] = 1
                    }
                }
            }
            sum = liftDictionary.values.reduce(0, combine: +)
        } catch {
            let nserror = error as NSError
            print("Fetch error: \(nserror)")
        }
        return (liftDictionary, sum)
    }
    
    /****************************************************************************
     *
     *****************************************************************************/
    func getAllLiftStrings() -> [String]
    {
        let request = NSFetchRequest(entityName: "SessionEntity")

        var liftStringSet = Set<String>()
        do {
            let results = try managedObject.executeFetchRequest(request) as! [SessionEntity]
            for result:SessionEntity in results
            {
                let overViewArr = result.overView!.characters.split{$0 == ","}.map(String.init)
                for lift:String in overViewArr
                {
					liftStringSet.insert(lift)
                }
            }
			let sortedList = Array(liftStringSet).sort()
            return sortedList
        } catch {
            let nserror = error as NSError
            print("Fetch error: \(nserror)")
        }

        return []
    }
}