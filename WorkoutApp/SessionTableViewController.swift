//
//  SessionTableViewController.swift
//  WorkoutApp
//
//  Created by Nick on 10/4/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SessionTableViewController: UIViewController
{
  @IBOutlet weak var myTableView: UITableView!
  
  var sessionId:NSManagedObjectID?
  var session:SessionEntity?
  var setsArray:[[SetEntity]]?
  var selectedDate:NSDate?
  var selectedIndexPath:NSIndexPath?
  var emptySetView: UIView?
  
  /****************************************************************************
   *
   *****************************************************************************/
  override func viewDidLoad()
  {
    self.view.backgroundColor = PRIMARY_COLOR
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")
    
    // Setup back button title for next view
    let backButton = UIBarButtonItem(title: "Session", style: .Bordered, target: nil, action: nil)
    self.navigationItem.backBarButtonItem = backButton

    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    let dateString = formatter.stringFromDate(selectedDate!)
    self.title = dateString
    configureView()
  }
  
  func addWorkout() {
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddLiftView") as! AddLiftController
    vc.session = session
		vc.date = selectedDate
    vc.delegate = self
    self.presentViewController(vc, animated: true, completion: nil)
  }
  
  @IBAction func swipedRight(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func configureView() {
    // Empty Set handling
    if sessionId == nil {
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addWorkout")
      emptySetView = NSBundle.mainBundle().loadNibNamed("EmptyDataView", owner: nil, options: nil)[0] as? UIView
      emptySetView!.frame = view.frame
      emptySetView!.backgroundColor = PRIMARY_COLOR
      self.view.addSubview(emptySetView!)
    } else {
      emptySetView?.hidden = true
      emptySetView?.removeFromSuperview()
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: "openMenu")

      (session, setsArray) = CDSessionHelper().getSession(sessionId!)
      myTableView.reloadData()
      if selectedIndexPath != nil {
        myTableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
      }
    }
  }
  
  func setViewAlpha(alpha: CGFloat) {
    UIView.animateWithDuration(0.3) {
      self.view.alpha = alpha
    }
  }

  func backButtonPressed(sender:UIButton) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == "liftDetailSegue"
    {
      let vc = segue.destinationViewController as! LiftDetailController
      vc.selectedSet = setsArray![selectedIndexPath!.row][selectedIndexPath!.section]
    }
  }
}


/****************************************************************************
 *	MARK: UITableViewDelegate
 *****************************************************************************/
extension SessionTableViewController: UITableViewDelegate
{
  /****************************************************************************
   *
   *****************************************************************************/
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
//    selectedIndexPath = indexPath
//    performSegueWithIdentifier("liftDetailSegue", sender: self)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      for set in setsArray![indexPath.row] {
        CDSetHelper().deleteLift(session!, set: set)
      }
      setsArray?.removeAtIndex(indexPath.row)
      if setsArray!.isEmpty {
        CDSessionHelper().deleteSession(session!)
        sessionId = nil
        session = nil
        configureView()
      }
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
  }
  
}

/****************************************************************************
 *	MARK: UITableViewDataSource
 *****************************************************************************/
extension SessionTableViewController: UITableViewDataSource
{
  /****************************************************************************
   *
   *****************************************************************************/
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    var cell:LiftDataCell?
    if cell == nil {
      tableView.registerNib(UINib(nibName: "LiftDataCell", bundle: nil), forCellReuseIdentifier: "liftCell")
    }
    cell = tableView.dequeueReusableCellWithIdentifier("liftCell") as? LiftDataCell
    cell!.delegate = self
    cell!.indexPath = indexPath
    cell!.liftName.text = setsArray![indexPath.row][0].movementType
    
    var setText = ""
    
    for (index, set) in setsArray![indexPath.row].enumerate() {
      setText += "Set \(index + 1): \(set.repCount!) x \(set.weight!) lbs\n"
    }
    
    setText = setText.stringByPaddingToLength(setText.characters.count - 1, withString: "", startingAtIndex: 0)
    cell!.setLabel.text = setText
    cell!.insetView.layer.cornerRadius = 20
    cell!.backgroundColor = PRIMARY_COLOR
    
    return cell!
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return setsArray != nil ? setsArray!.count : 0
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let sets = setsArray![indexPath.row].count
    let linesHeight = sets * 21
    let height = CGFloat(linesHeight + 80)
    return height
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

extension SessionTableViewController
{
  func openMenu() {
    let menu = SessionMenu()
    menu.delegate = self
    menu.modalPresentationStyle = .Popover
    menu.preferredContentSize = CGSize(width: 220, height: 122)
    let popoverView = menu.popoverPresentationController
    popoverView?.permittedArrowDirections = .Up
    popoverView?.delegate = self
    popoverView?.sourceView = self.view
    menu.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

//    UIView.animateWithDuration(2.0, animations: {
//      navigationItem.rightBarButtonItem?.image.transform = CGAffineTransformMakeRotation((90 * CGFloat(M_PI)) / 90)
//    })
    
    presentViewController(menu, animated: true, completion: nil)
    setViewAlpha(0.5)
  }

}

/**************************************************************************
 *
 ***************************************************************************/
extension SessionTableViewController: LiftDataCellDelegate
{
  func addSetPressed(indexPath:NSIndexPath) {
    let quickLiftView = AddLiftQuick()
    quickLiftView.delegate = self
		quickLiftView.modalPresentationStyle = .Popover
    quickLiftView.preferredContentSize = CGSize(width: 300, height: 150)
    let popoverView = quickLiftView.popoverPresentationController
    popoverView?.permittedArrowDirections = .Down
    popoverView?.delegate = self
    popoverView?.sourceView = self.view
    
    popoverView?.sourceRect = CGRect(
      x: view.bounds.width/2.0 - quickLiftView.preferredContentSize.width/2.0,
      y: view.bounds.height/2.0 + quickLiftView.preferredContentSize.height/2.0,
      width: CGFloat(300.0),
      height: CGFloat(150.0))
    presentViewController(quickLiftView, animated: true, completion: nil)
    setViewAlpha(0.5)

    quickLiftView.liftName.text = setsArray![indexPath.row][0].movementType!
    quickLiftView.setSessionObject(session!)

  }
}

/**************************************************************************
 *
 ***************************************************************************/
extension SessionTableViewController: AddLiftQuickDelegate
{
  func didDismissPopover() {
    setViewAlpha(1)
  }
  
  func addedSet() {
    setViewAlpha(1)
    (session, setsArray) = CDSessionHelper().getSession(sessionId!)
		myTableView.reloadData()
  }
  
  func editLiftPressed(indexPath: NSIndexPath) {
    selectedIndexPath = indexPath
		performSegueWithIdentifier("liftDetailSegue", sender: self)
  }
}

/**************************************************************************
 *
 ***************************************************************************/
extension SessionTableViewController: UIPopoverPresentationControllerDelegate
{
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
  
  func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
    UIView.animateWithDuration(0.3) {
      self.view.alpha = 1
    }
  }
}

/**************************************************************************
 *
 ***************************************************************************/
extension SessionTableViewController: SessionMenuDelegate
{
  func didSelectDeleteWorkout() {
    let deleteAlert = UIAlertController(title: nil, message: "Are you sure you want to delete this workout?", preferredStyle: .ActionSheet)
    deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
      CDSessionHelper().deleteSession(self.session!)
      self.sessionId = nil
      self.session = nil
      self.configureView()
      self.setViewAlpha(1)
    }))
    
    deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
      self.setViewAlpha(1)
    }))
    
    presentViewController(deleteAlert, animated: true, completion: nil)
  }
  
  func didSelectDeleteLift() {
		myTableView.editing = true
    setViewAlpha(1)

  }
  
  func didSelectAddLift() {
		addWorkout()
    setViewAlpha(1)

  }
}

/**************************************************************************
 *
 ***************************************************************************/
extension SessionTableViewController: AddLiftDelegate
{
  func didSaveSet(sessionId:NSManagedObjectID) {
    self.sessionId = sessionId
    configureView()
  }
}