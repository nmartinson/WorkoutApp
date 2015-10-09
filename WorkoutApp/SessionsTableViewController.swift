//
//  SessionsTableViewController.swift
//  WorkoutApp
//
//  Created by Nick on 10/4/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

class SessionsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var myTableView: UITableView!
    var sessions:[SessionEntity] = []
    var selectedRow:Int?
    
    /**************************************************************************
    *
    ***************************************************************************/
    override func viewDidLoad()
    {
        self.sessions = CDSessionHelper().getSessions()
        myTableView.reloadData()
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sessionCell")
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        let dateString = formatter.stringFromDate(sessions[indexPath.row].date!)
        cell?.textLabel?.text = dateString
		return cell!
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
		selectedRow = indexPath.row
        performSegueWithIdentifier("toSession", sender: self)
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let vc = segue.destinationViewController as! SessionTableViewController
        vc.sessionId = sessions[selectedRow!].objectID
    }

}