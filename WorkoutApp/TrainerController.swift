//
//  TrainerController.swift
//  WorkoutApp
//
//  Created by Nick on 11/10/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity
import TextFieldEffects


class TrainerController: UIViewController, WCSessionDelegate
{
  @IBOutlet weak var movementField: YoshikoTextField!
  @IBOutlet weak var repCountField: UITextField!
  @IBOutlet weak var trainDataButton: UIButton!
  @IBOutlet weak var infoLabel: UILabel!
  
  var session: WCSession? {
    didSet {
      if let session = session {
        session.delegate = self
        session.activateSession()
      }
    }
  }
  
  
  /**************************************************************************
   *
   ***************************************************************************/
  override func viewDidLoad()
  {
    view.backgroundColor = PRIMARY_COLOR
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")
    
    movementField.bounds.size.height = 60
    trainDataButton.enabled = false
    if (WCSession.defaultSession().reachable)
    {
      infoLabel.text = "REACHABLE"
    } else {
      infoLabel.text = "NOT REACHABLE"
    }
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func backButtonPressed(sender:UIButton) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func isMovementValid() -> Bool
  {
    let movement = movementField.text
    
    if movement != "" && movement != nil
    {
      return true
    }
    return false
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func isRepCountValid() -> Bool
  {
    let repCountString = repCountField.text
    
    if repCountString != "" && repCountString != nil
    {
      let repCount = Int(repCountString!)
      if repCount > 0
      {
        return true
      }
    }
    return false
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  @IBAction func trainDataPressed(sender: AnyObject)
  {
    let repCount = Int(repCountField.text!)
    let trainData:[String: AnyObject] = ["movementType": movementField.text!, "repCount": repCount!]
    let message = ["trainData": trainData]
    
    //        session = WCSession.defaultSession()
    
    WCSession.defaultSession().sendMessage(message, replyHandler: {replyDict in }, errorHandler:
      { error in
        self.infoLabel.text = "\(error)"
        print("ERROR \(error)")
    } )
  }
}

/**************************************************************************
 *	MARK: UITextFieldDelegate
 ***************************************************************************/
extension TrainerController: UITextFieldDelegate
{
  /**************************************************************************
   *
   ***************************************************************************/
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == movementField {
      repCountField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func textFieldDidEndEditing(textField: UITextField)
  {
    if isMovementValid() && isRepCountValid() {
      trainDataButton.enabled = true
    } else {
      trainDataButton.enabled = false
    }
  }
}
