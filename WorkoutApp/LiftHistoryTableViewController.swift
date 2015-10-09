//
//  LiftHistoryTableViewController.swift
//  WorkoutApp
//
//  Created by Nick on 10/7/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

class LiftHistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var myTableView: UITableView!
    
    var allLifts:[String] = []
    var selectedIndex:Int?
    
    override func viewDidLoad() {
        allLifts = CDSessionHelper().getAllLiftStrings()
        myTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("liftCell")
		cell?.textLabel?.text = allLifts[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedIndex = indexPath.row
        print("SELECTED")
    	performSegueWithIdentifier("toLiftHistory", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLifts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toLiftHistory"
        {
            let vc = segue.destinationViewController as! LiftHistoryController
            vc.liftString = allLifts[selectedIndex!]
        }
    }
    
}