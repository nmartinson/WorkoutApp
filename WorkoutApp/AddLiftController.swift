//
//  AddLiftController.swift
//  WorkoutApp
//
//  Created by Nick on 11/23/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import CoreData


extension AddLiftController: UITableViewDataSource
{
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

extension AddLiftController: UITableViewDelegate
{
  
}

extension AddLiftController: UITextFieldDelegate
{
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField == liftNameField {
      tableViewSearchResults.hidden = false
			self.view.bringSubviewToFront(tableViewSearchResults)
      cancelSearchButton.hidden = false
      
      tableViewSetData.hidden = true
      
      UIView.animateWithDuration(1) {
        let buttonWidth = self.cancelSearchButton.bounds.size.width + 10

        self.liftNameTrailingConstraint.constant = buttonWidth
        self.cancelSearchButton.hidden = false
      }
    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == liftNameField {
      tableViewSearchResults.hidden = true
      cancelSearchButton.hidden = true

//      tableViewSetData.hidden = false
    }
  }
}

class AddLiftController: UIViewController
{
  @IBOutlet weak var liftNameTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cancelSearchButton: UIButton!
  @IBOutlet weak var liftNameField: YoshikoTextField!
  @IBOutlet weak var repField: YoshikoTextField!
  @IBOutlet weak var weightField: YoshikoTextField!
  @IBOutlet weak var tableViewSearchResults: UITableView!
  @IBOutlet weak var tableViewSetData: UITableView!
  
  var allLifts: [MovementsEntity]?
  
  lazy var test = {
    return CDMovementHelper().getMovements()
  }
  
  override func viewDidLoad() {
    
  }
  
  @IBAction func createSetPressed(sender: AnyObject) {
    
  }
  
  @IBAction func cancelPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func savePressed(sender: AnyObject) {

  }
  
  @IBAction func cancelSearchPressed(sender: AnyObject) {
    liftNameField.resignFirstResponder()
    UIView.animateWithDuration(1) {
      self.cancelSearchButton.hidden = true
      self.liftNameTrailingConstraint.constant = 0
      
      self.tableViewSearchResults.hidden = true
    }
  }
  
}