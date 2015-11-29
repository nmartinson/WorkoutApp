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

class SessionTableViewController: UIViewController
{
    @IBOutlet weak var myTableView: UITableView!

    var sessionId:NSManagedObjectID?
    var session:SessionEntity?
    var setsArray:[[SetEntity]]?
    var selectedIndexPath:NSIndexPath?
    
    /****************************************************************************
    *
    *****************************************************************************/
    override func viewDidLoad()
    {
        self.view.backgroundColor = PRIMARY_COLOR
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")

        (session, setsArray) = CDSessionHelper().getSession(sessionId!)
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        let dateString = formatter.stringFromDate(session!.date!)
        self.title = dateString
        
        // Setup back button title for next view
        let backButton = UIBarButtonItem(title: "Session", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidAppear(animated: Bool) {
        if selectedIndexPath != nil {
            myTableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
        }
    }
    
    @IBAction func swipedRight(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    /****************************************************************************
    *
    *****************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
    	if segue.identifier == "liftDetailSegue"
        {
            let vc = segue.destinationViewController as! LiftDetailController
            vc.selectedSet = setsArray![selectedIndexPath!.section][selectedIndexPath!.row]
        }
    }
    
}


/****************************************************************************
 *	MARK: UITableViewDelegate
 *****************************************************************************/
extension SessionTableViewController: UITableViewDelegate
{
    /****************************************************************************
     *
     *****************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedIndexPath = indexPath
        performSegueWithIdentifier("liftDetailSegue", sender: self)
    }
}

/****************************************************************************
 *	MARK: UITableViewDataSource
 *****************************************************************************/
extension SessionTableViewController: UITableViewDataSource
{
    /****************************************************************************
     *
     *****************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("liftCell")
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.text = "Weight: \(setsArray![indexPath.section][indexPath.row].weight!)"
        return cell!
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
}