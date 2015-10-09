//
//  SessionTableViewController.swift
//  WorkoutApp
//
//  Created by Nick on 10/4/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SessionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var myTableView: UITableView!

    var sessionId:NSManagedObjectID?
    var session:SessionEntity?
    var setsArray:[[SetEntity]]?
    
    /****************************************************************************
    *
    *****************************************************************************/
    override func viewDidLoad()
    {
        (session, setsArray) = CDSessionHelper().getSession(sessionId!)
    }
    
    /****************************************************************************
    *
    *****************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("liftCell")
        
        cell?.textLabel?.text = "Weight: \(setsArray![indexPath.section][indexPath.row].weight!)"
        return cell!
    }
    
    /****************************************************************************
    *
    *****************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    /****************************************************************************
    *
    *****************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsArray![section].count
    }
    
    /****************************************************************************
    *
    *****************************************************************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return setsArray!.count
    }
    
    /****************************************************************************
    *
    *****************************************************************************/
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return setsArray![section][0].movementType
    }
    
    /****************************************************************************
    *
    *****************************************************************************/
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?)
    {
        
    }
    
}