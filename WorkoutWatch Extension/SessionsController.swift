//
//  InterfaceController.swift
//  WorkoutWatch Extension
//
//  Created by Nick on 10/7/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class SessionsController: WKInterfaceController {
  
  @IBOutlet var responseLabel: WKInterfaceLabel!
  let session = WCSession.defaultSession()
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    self.setTitle("Sessions")

    // Configure interface objects here.
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    
    let dict:[String: AnyObject] = ["request": "workouts"]
    session.sendMessage(dict, replyHandler: {
      (replyDict: [String: AnyObject]) in
      	self.responseLabel.setText(replyDict["response"]! as? String)
      }, errorHandler: { error in} )
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
}
