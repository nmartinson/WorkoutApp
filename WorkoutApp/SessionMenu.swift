//
//  SessionMenu.swift
//  WorkoutApp
//
//  Created by Nick on 12/2/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit

protocol SessionMenuDelegate
{
  func didSelectDeleteWorkout()
  func didSelectDeleteLift()
  func didSelectAddLift()
  func didDismissPopover()
}

class SessionMenu: UIViewController {
  
  var delegate:SessionMenuDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func addLiftPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: {
      self.delegate?.didSelectAddLift()
		})
  }
  
  @IBAction func deleteLiftPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: {
      self.delegate?.didSelectDeleteLift()
    })
  }
  
  @IBAction func deleteWorkoutPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: {
      self.delegate?.didSelectDeleteWorkout()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
