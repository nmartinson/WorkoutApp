//
//  EditLiftController.swift
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
class EditLiftController: UIViewController
{
  @IBOutlet weak var tableViewSets: UITableView!
  
  var session:SessionEntity?
  var setId:NSManagedObjectID?
  var allLifts: [MovementsEntity]?
  var date:NSDate?
  var delegate:LiftDelegate?
  var setsToEdit:[SetEntity] = []
  var setsToDelete:[SetEntity] = []
  var movement: String?
  
  enum InputError: ErrorType {
    case InputMissing
  }
  
  override func viewDidLoad() {
    movement = setsToEdit.first?.movementType!
  }
  
  
  @IBAction func cancelPressed(sender: AnyObject) {
    delegate?.didCancel()
    dismissViewControllerAnimated(true, completion: {    CDSetHelper().undoChanges()
		})
  }
  
  @IBAction func savePressed(sender: AnyObject) {
    do {
      try saveSet()
      let didDeleteSession = CDSetHelper().deleteSets(setsToDelete, session: session!, deleteFromOverView: setsToEdit.isEmpty)
      if didDeleteSession {
        delegate?.didDeleteSession()
      } else {
	      delegate?.didSaveSet(session!.objectID)
      }
      
      dismissViewControllerAnimated(true, completion: nil)
    } catch InputError.InputMissing {
      showAlertForEmptryFields()
    } catch { }
  }
  
  
  func saveSet() throws -> AnyObject? {
    for row in 0..<setsToEdit.count {
      let indexPath = NSIndexPath(forRow: row, inSection: 0)
      let cell = tableViewSets.cellForRowAtIndexPath(indexPath) as! EditLiftCell
      guard let weight = Double(cell.weightField.text!), let repCount = Int(cell.repsField.text!) else {
        throw InputError.InputMissing
      }
      CDSetHelper().updateSet(setsToEdit[row], weight: weight, repCount: repCount)
    }
    return nil
  }
  
  func showAlertForEmptryFields(){
    let alert = UIAlertController(title: "Woah there!", message: "Make sure not to leave any rep or weight blank", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }
  
}

extension EditLiftController: UITableViewDelegate
{
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
//      CDSetHelper().deleteSetTemporary(setsToEdit[indexPath.row])

      setsToDelete.append(setsToEdit[indexPath.row])
      setsToEdit.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
  }

}

/****************************************************************************
 *	TableView Datasource
 *****************************************************************************/
extension EditLiftController: UITableViewDataSource
{
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
     if cell == nil {
      tableView.registerNib(UINib(nibName: "EditLiftCell", bundle: nil), forCellReuseIdentifier: "editSetCell")
    }
    cell = tableView.dequeueReusableCellWithIdentifier("editSetCell")
    
    (cell as! EditLiftCell).setLabel.text = "Set \(indexPath.row + 1)"
    (cell as! EditLiftCell).weightField.text = setsToEdit[indexPath.row].weight!.stringValue
    (cell as! EditLiftCell).repsField.text = setsToEdit[indexPath.row].repCount!.stringValue
    return cell!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return setsToEdit.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}
