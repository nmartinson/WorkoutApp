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

/****************************************************************************
 *
 *****************************************************************************/
extension AddLiftController: UITableViewDataSource
{
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    if tableView == tableViewSearchResults {
      cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell")
      if isSearching {
        cell?.textLabel?.text = filteredMovements[indexPath.row] as? String
      } else {
        cell?.textLabel?.text = movements[indexPath.row]
      }
      cell?.textLabel?.textColor = UIColor.whiteColor()
    } else {
      if cell == nil {
        tableView.registerNib(UINib(nibName: "EditLiftCell", bundle: nil), forCellReuseIdentifier: "editSetCell")
      }
      cell = tableView.dequeueReusableCellWithIdentifier("editSetCell")

      (cell as! EditLiftCell).setLabel.text = "Set \(indexPath.row + 1)"
      (cell as! EditLiftCell).weightField.text = setsToCreate[indexPath.row].weight!.stringValue
      (cell as! EditLiftCell).repsField.text = setsToCreate[indexPath.row].repCount!.stringValue
    }
    return cell!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == tableViewSearchResults {
      if isSearching {
        return filteredMovements.count
      }
      return movements.count
    } else {
      return setsToCreate.count
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if tableView == tableViewSearchResults {
			return 44
    } else {
      return 60
    }
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

/****************************************************************************
 *
 *****************************************************************************/
extension AddLiftController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if tableView == tableViewSearchResults {
      liftNameField.text = filteredMovements[indexPath.row] as? String
      liftNameField.resignFirstResponder()
      isSearching = false
      tableViewSearchResults.hidden = true
    } else {
      
    }
  }
}

/****************************************************************************
 *
 *****************************************************************************/
extension AddLiftController: UITextFieldDelegate
{
  func search(shouldClear: Bool) {
    var searchText = " "
    if shouldClear == false {
      searchText = liftNameField.text!
    }
    
    filteredMovements = movements.filter({ (lift) -> Bool in
      let liftText: NSString = lift
      
      return (liftText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
    })
    tableViewSearchResults.reloadData()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == liftNameField {
      textField.resignFirstResponder()
    } else if textField == repField {
      weightField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
  
  
  func textFieldShouldClear(textField: UITextField) -> Bool {
    search(true)
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    search(false)
    return true
  }
  
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField == liftNameField {
      isSearching = true
      search(true)
      tableViewSearchResults.hidden = false
      tableViewSets.hidden = true
      self.view.bringSubviewToFront(tableViewSearchResults)
      cancelSearchButton.hidden = false
      
      UIView.animateWithDuration(1) {
        let buttonWidth = self.cancelSearchButton.bounds.size.width + 10
        
        self.liftNameTrailingConstraint.constant = buttonWidth
        self.cancelSearchButton.hidden = false
      }
    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == liftNameField {
      isSearching = false
      tableViewSearchResults.hidden = true
      tableViewSets.hidden = false
      cancelSearchButton.hidden = true
    }
  }
}

protocol AddLiftDelegate
{
  func didSaveSet(sessionId:NSManagedObjectID)
}

/****************************************************************************
 *
 *****************************************************************************/
class AddLiftController: UIViewController
{
  @IBOutlet weak var liftNameTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cancelSearchButton: UIButton!
  @IBOutlet weak var liftNameField: YoshikoTextField!
  @IBOutlet weak var repField: YoshikoTextField!
  @IBOutlet weak var weightField: YoshikoTextField!
  @IBOutlet weak var tableViewSearchResults: UITableView!
  @IBOutlet weak var tableViewSets: UITableView!
  
  var session:SessionEntity?
  var isSearching = false
  var movements = ["Barbell Curls", "Dumbbell Curls", "Bench Press", "Squat", "Dead Lift", "Pull Up", "Push Up"]
  var filteredMovements = []
  var allLifts: [MovementsEntity]?
  var date:NSDate?
  var delegate:AddLiftDelegate?
  var setsToCreate:[SetEntity] = []
  
  override func viewDidLoad() {
    setsToCreate.removeAll()
  }
  
  @IBAction func createSetPressed(sender: AnyObject) {
    guard let weight = Double(weightField.text!), let repCount = Int(repField.text!), let movement = liftNameField.text else { return }
		let set = CDSetHelper().addTemporarySet(weight, repCount: repCount, movement: movement)
    setsToCreate.append(set)
    tableViewSets.reloadData()
  }
  
  @IBAction func cancelPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func savePressed(sender: AnyObject) {
    guard let weight = Double(weightField.text!), let repCount = Int(repField.text!), let movement = liftNameField.text else { return }

    if session == nil {
      session = CDSessionHelper().createSession(date!)
      // if they didn't add the set first and just pressed save
      if setsToCreate.isEmpty {
        CDSetHelper().addSet(session!, weight: weight, repCount: repCount, movement: movement)
      } else {
        for set in setsToCreate {
          CDSetHelper().addSet(session!, weight: set.weight!, repCount: set.repCount!, movement: set.movementType!)
        }
      }
    } else {
      for set in setsToCreate {
        CDSetHelper().addSet(session!, weight: set.weight!, repCount: set.repCount!, movement: set.movementType!)
      }
    }
    delegate?.didSaveSet(session!.objectID)
    dismissViewControllerAnimated(true, completion: nil)
    
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