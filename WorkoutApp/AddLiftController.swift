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


protocol LiftDelegate
{
  func didSaveSet(sessionId:NSManagedObjectID)
  func didDeleteSession()
  func didCancel()
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
  @IBOutlet weak var repWeightStack: UIStackView!
  
  var session:SessionEntity?
  var isSearching = false
  var movements:[String] = []
  var filteredMovements = []
  var allLifts: [MovementsEntity]?
  var date:NSDate?
  var delegate:LiftDelegate?
  var setsToCreate:[SetEntity] = []
  
  enum InputError: ErrorType {
    case InputMissing
  }
  
  override func viewDidLoad() {
    movements = CDMovementHelper().getMovementNames()
    setsToCreate.removeAll()
  }
  
  @IBAction func createSetPressed(sender: AnyObject) {
    guard let weight = Double(weightField.text!), let repCount = Int(repField.text!), let movement = liftNameField.text else { return }
    let set = CDSetHelper().addTemporarySet(weight, repCount: repCount, movement: movement)
    setsToCreate.append(set)
    tableViewSets.reloadData()
  }
  
  @IBAction func cancelPressed(sender: AnyObject) {
    delegate?.didCancel()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func savePressed(sender: AnyObject) {
    guard let weight = Double(weightField.text!), let repCount = Int(repField.text!), let movement = liftNameField.text else { return }
    
    if session == nil {
      session = CDSessionHelper().createSession(date!)
      // if they didn't add the set first and just pressed save
      if setsToCreate.isEmpty {
        CDSetHelper().addSet(session!, weight: weight, repCount: repCount, movement: movement)
        delegate?.didSaveSet(session!.objectID)
        dismissViewControllerAnimated(true, completion: nil)
      } else {
        do {
          try saveSets()
          delegate?.didSaveSet(session!.objectID)
          dismissViewControllerAnimated(true, completion: nil)
        } catch InputError.InputMissing {
          showAlertForEmptryFields()
        } catch { }
      }
    } else {
      do {
        try saveSets()
        delegate?.didSaveSet(session!.objectID)
        dismissViewControllerAnimated(true, completion: nil)
      } catch InputError.InputMissing {
        showAlertForEmptryFields()
      } catch { }
    }
  }
  
  
  func saveSets() throws -> AnyObject? {
    guard let movement = liftNameField.text else { throw InputError.InputMissing }
    for row in 0..<setsToCreate.count {
      let indexPath = NSIndexPath(forRow: row, inSection: 0)
      let cell = tableViewSets.cellForRowAtIndexPath(indexPath) as! EditLiftCell
      guard let weight = Double(cell.weightField.text!), let repCount = Int(cell.repsField.text!) else {
        throw InputError.InputMissing
      }
      CDSetHelper().addSet(session!, weight: weight, repCount: repCount, movement: movement)
    }
    CDMovementHelper().addMovementName(movement)
    return nil
  }
  
  @IBAction func cancelSearchPressed(sender: AnyObject) {
    liftNameField.resignFirstResponder()
    UIView.animateWithDuration(1) {
      self.cancelSearchButton.hidden = true
      self.liftNameTrailingConstraint.constant = 0
      self.tableViewSearchResults.hidden = true
    }
  }
  
  func showAlertForEmptryFields(){
    let alert = UIAlertController(title: "Woah there!", message: "Make sure not to leave any rep or weight blank", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }
  
}

/****************************************************************************
 *	TableView Datasource
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
 *	TableView Delegate
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
 *	TextField Delegate
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
