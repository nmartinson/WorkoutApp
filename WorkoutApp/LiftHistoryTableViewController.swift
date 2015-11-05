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
    var selectedIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        self.title = "Lift History"
        self.view.backgroundColor = PRIMARY_COLOR
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")

        allLifts = CDSessionHelper().getAllLiftStrings()
        myTableView.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("liftCell")
        cell?.textLabel?.textColor = UIColor.whiteColor()
		cell?.textLabel?.text = allLifts[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedIndexPath = indexPath
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
            vc.liftString = allLifts[selectedIndexPath!.row]
        }
    }
    
}