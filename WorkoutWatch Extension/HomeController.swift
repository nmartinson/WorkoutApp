//
//  HomeController.swift
//  FocusMotionTesting
//
//  Created by Nick Martinson on 9/20/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class HomeController: WKInterfaceController, FmLocalDeviceDelegate {
  @IBOutlet var startWorkoutbutton: WKInterfaceButton!
  @IBOutlet var trainButton: WKInterfaceButton!
  @IBOutlet var viewWorkoutsButton: WKInterfaceButton!
  
  override func awakeWithContext(context: AnyObject?) {
    self.setTitle("Workout App")
    let PRIMARY_COLOR = UIColor(red: 0/255, green: 103/255, blue: 255/255, alpha: 1)

    startWorkoutbutton.setBackgroundColor(PRIMARY_COLOR)
    trainButton.setBackgroundColor(PRIMARY_COLOR)
    viewWorkoutsButton.setBackgroundColor(PRIMARY_COLOR)
  }
  
  @IBAction func startWorkout()
  {
    WKInterfaceController.reloadRootControllers([(name: "Workout", context: [])])
    
  }
  
  @IBAction func viewWorkouts() {

    
  }
  
  
  
  
  
}