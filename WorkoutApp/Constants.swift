//
//  Constants.swift
//  WorkoutApp
//
//  Created by Nick on 10/30/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

let MAIN_COLOR = UIColor(hue: 255, saturation: 0, brightness: 0, alpha: 1)
let PRIMARY_COLOR = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
//let BAR_TINT_COLOR = UIColor(colorLiteralRed: 0, green: 103, blue: 255, alpha: 1.0)
let BAR_TINT_COLOR = UIColor(red: 0/255, green: 103/255, blue: 255/255, alpha: 1)
let BACK_IMG: UIImage = UIImage(named: "back_button_white")!

enum MuscleGroup: String {
  case Lower = "Legs"
  case Core = "Core"
  case Chest = "Chest"
  case Shoulders = "Shoulders"
  case Arms = "Arms"
  case Back = "Back"
  case Groups = "Groups"
}