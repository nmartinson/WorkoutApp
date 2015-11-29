//
//  CalendarMenuControllerViewController.swift
//  WorkoutApp
//
//  Created by Nick on 11/25/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

protocol CalendarMenuDelegate
{
 	func didSelectWorkout(sessionID: NSManagedObjectID)
}

class CalendarMenuControllerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var delegate:CalendarMenuDelegate?
  var sessions:[SessionEntity] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  func setWorkoutData(sessions: [SessionEntity]){
    self.sessions = sessions
    self.tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sessions.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let formatter = NSDateFormatter()
    formatter.dateStyle = .NoStyle
    formatter.timeStyle = .ShortStyle
//    sessions[indexPath.row].
    let dateString = formatter.stringFromDate(sessions[indexPath.row].date!)
//    cell.textLabel?.textColor = UIColor.whiteColor()
    cell.textLabel?.text = dateString
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 35
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    delegate?.didSelectWorkout(sessions[indexPath.row].objectID)
  }
  
}
