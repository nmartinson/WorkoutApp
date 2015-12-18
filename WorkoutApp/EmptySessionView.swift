//
//  EmptySessionView.swift
//  WorkoutApp
//
//  Created by Nick on 12/8/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

protocol EmptySessionDelegate
{
  func didPressAddSet()
}

class EmptySessionView: UIView
{
  var delegate: EmptySessionDelegate?
  @IBAction func addLiftPressed(sender: AnyObject) {
    delegate?.didPressAddSet()
  }
  
}