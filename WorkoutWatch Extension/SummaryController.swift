//
//  SummaryController.swift
//  WorkoutApp
//
//  Created by Nick on 10/27/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class SummaryController: WKInterfaceController {
  var setData:[SetEntity]?
  //    let session = WCSession.defaultSession()
  var workoutStartDate:NSDate?
  var workoutDuration:Float?
  @IBOutlet var tableView: WKInterfaceTable!
  
  /**********************************************************************
   *
   **********************************************************************/
  override func awakeWithContext(context: AnyObject?) {
    self.setTitle("Summary")
    guard let data = context as? Dictionary<String,AnyObject> else {return}
    setData = data["setData"] as? [SetEntity]
    workoutStartDate = data["sessionStartDate"] as? NSDate
    workoutDuration = data["sessionDuration"] as? Float
    configurateTable()
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func configurateTable()
  {
    tableView.setNumberOfRows(setData!.count, withRowType: "WorkoutRow")
    for(var i = 0; i < tableView.numberOfRows; i++)
    {
      let row = self.tableView.rowControllerAtIndex(i) as! WorkoutRow
      row.textLabel.setText(setData![i].movementType)
    }
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  @IBAction func savePressed()
  {
    let sessionData:[String: AnyObject] = ["workoutStartDate": self.workoutStartDate!, "workoutDuration": NSDate().timeIntervalSinceDate(workoutStartDate!)]
    let message = ["sessionData": sessionData]
    
    WCSession.defaultSession().transferUserInfo(message)
//    WCSession.defaultSession().sendMessage(message, replyHandler: {replyDict in }, errorHandler: { error in} )
    
    let length = setData!.count
    for (index,set) in setData!.enumerate()
    {
      
      var lastLift = false
      let movement = set.movementType!
      let reps = set.repCount!
      let duration = set.duration!
      let meanRepTime = set.meanRepTime!
      let maxRepTime = set.maxRepTime!
      let minRepTime = set.minRepTime!
      let internalVariation = set.internalVariation!
      if(index == length - 1){ lastLift = true }
      let workoutData:[String: AnyObject] = ["movementType": movement,
        "repCount": Int(reps),
        "duration": duration,
        "meanRepTime": meanRepTime,
        "minRepTime": minRepTime,
        "maxRepTime": maxRepTime,
        "internalVariation": internalVariation,
        "lastLift": lastLift]
      let message = ["workoutData": workoutData]
      WCSession.defaultSession().transferUserInfo(message)
      //WCSession.defaultSession().sendMessage(message, replyHandler: {replyDict in }, errorHandler: { error in} )
    }
    
    WKInterfaceController.reloadRootControllers([(name: "Home", context: [])])
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  @IBAction func discardPressed()
  {
    setData = nil
    workoutStartDate = nil
    workoutDuration = nil
    WKInterfaceController.reloadRootControllers([(name: "Home", context: [])])
  }
  
}