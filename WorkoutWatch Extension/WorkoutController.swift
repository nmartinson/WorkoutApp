//
//  WorkoutController.swift
//  FocusMotionTesting
//
//  Created by Nick Martinson on 9/20/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import WatchKit

class WorkoutController: WKInterfaceController {

    @IBOutlet weak var workoutTable: WKInterfaceTable!
    var sessions = []
    
    override func awakeWithContext(context: AnyObject?) {
        sessions = ["Hello", "Hey", "Howdy","Hello", "Hey", "Howdy"]
        reloadTable()
    }
    
    func reloadTable(){
        workoutTable.setNumberOfRows(sessions.count, withRowType: "WorkoutRow")
//        for(index, row) in enumerate(sessions){
//            if let row = workoutTable.rowControllerAtIndex(index) as? WorkoutRow {
//                row.textLabel.setText(sessions[index] as? String)
//            }
//        }
        
    }
}
