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
    
    override func awakeWithContext(context: AnyObject?) {
        
    }
    
    @IBAction func startWorkout()
    {
        WKInterfaceController.reloadRootControllers([(name: "Workout", context: [])])
        
    }
    
    @IBAction func viewWorkouts() {
        
    }

    

    
    
}