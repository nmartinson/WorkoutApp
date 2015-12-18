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
  var emptySessionView: UIView?
  var skipViewDidAppear = true
  var selectedCellIndexPath:NSIndexPath?
  var startTime = NSTimeInterval()
  var timer = NSTimer()
  var navTitleToggle = false

  
  func updateTime() {
    let currentTime = NSDate.timeIntervalSinceReferenceDate()
    //Find the difference between current time and start time.
    var elapsedTime: NSTimeInterval = currentTime - startTime
    //calculate the minutes in elapsed time.
    let minutes = UInt8(elapsedTime / 60.0)
    elapsedTime -= (NSTimeInterval(minutes) * 60)
    //calculate the seconds in elapsed time.
    let seconds = UInt8(elapsedTime)
    elapsedTime -= NSTimeInterval(seconds)
    //find out the fraction of milliseconds to be displayed.
    let fraction = UInt8(elapsedTime * 100) / 10
    //add the leading zero for minutes, seconds and millseconds and store them as string constants
    let strMinutes = String(format: "%02d", minutes)
    let strSeconds = String(format: "%02d", seconds)
    let strFraction = String(format: "%01d", fraction)
    //concatenate minuets, seconds and milliseconds as assign it to the UILabel
    if navTitleToggle {
    self.title = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
  }
  
  
  /****************************************************************************
   *
   *****************************************************************************/
  override func viewDidLoad()
  {
    self.view.backgroundColor = PRIMARY_COLOR
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")
    
    // Setup back button title for next view
    let backButton = UIBarButtonItem(title: "Session", style: .Plain, target: nil, action: nil)
    self.navigationItem.backBarButtonItem = backButton

    setNavBarDate()
    skipViewDidAppear = true

    configureView()
    
		addNavBarTapRecognizer()
  }
  
  func navSingleTap() {
    if navTitleToggle {
			setNavBarDate()
    } else {
      
    }
    navTitleToggle = !navTitleToggle
  }
  
  func setNavBarDate() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    let dateString = formatter.stringFromDate(selectedDate!)
    self.title = dateString
  }
  
  func addNavBarTapRecognizer() {
    let navSingleTap = UITapGestureRecognizer(target: self, action: "navSingleTap")
    navSingleTap.numberOfTapsRequired = 1
    navigationController?.navigationBar.subviews[0].userInteractionEnabled = true
    navigationController?.navigationBar.subviews[0].addGestureRecognizer(navSingleTap)
  }
  
  func removeNavBarTapRecognizer() {
    navigationController?.navigationBar.subviews[0].userInteractionEnabled = false
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  override func viewDidAppear(animated: Bool) {
    if !skipViewDidAppear {
      configureView()
    }
    skipViewDidAppear = false
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func addLift() {
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddLiftView") as! AddLiftController
    vc.session = session
		vc.date = selectedDate
    vc.delegate = self
    self.presentViewController(vc, animated: true, completion: nil)
  }
  
  func editLift() {
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("EditLiftView") as! EditLiftController
    vc.session = session
    vc.date = selectedDate
    vc.delegate = self
    vc.setsToEdit = setsArray![selectedIndexPath!.row]
    self.presentViewController(vc, animated: true, completion: nil)
  }
  
  @IBAction func swipedRight(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func configureView() {

    // Empty Set handling
    if sessionId == nil {
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addLift")
      emptySessionView = NSBundle.mainBundle().loadNibNamed("EmptySessionView", owner: nil, options: nil)[0] as? UIView
      emptySessionView!.frame = view.frame
      emptySessionView!.backgroundColor = PRIMARY_COLOR
      (emptySessionView as! EmptySessionView).delegate = self
      self.view.addSubview(emptySessionView!)
      stopTimer()
			setNavBarDate()
      removeNavBarTapRecognizer()
    } else {
      emptySessionView?.hidden = true
      emptySessionView?.removeFromSuperview()
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: "openMenu")
      (session, setsArray) = CDSessionHelper().getSession(sessionId!)

      myTableView.reloadData()
      if selectedIndexPath != nil {
        myTableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
      }
    }
  }
  
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    if emptySessionView != nil {
      emptySessionView?.frame = view.frame
    }
  }
  
  func stringFromTimeInterval(interval: NSTimeInterval) -> String {
    let interval = Int(interval)
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
//    let hours = (interval / 3600)
    return String(format: "%02d m %02d s",  minutes, seconds)
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func setViewAlpha(alpha: CGFloat) {
    UIView.animateWithDuration(0.3) {
      self.view.alpha = alpha
    }
  }

  /****************************************************************************
   *
   *****************************************************************************/
  func backButtonPressed(sender:UIButton) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    
  }
  
  func stopTimer() {
    timer.invalidate()
  }
  
  func resetTimer() {
    timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTime", userInfo: nil, repeats: true)
    startTime = NSDate.timeIntervalSinceReferenceDate()
  }
}


/****************************************************************************
 *	MARK: UITableViewDelegate
 *****************************************************************************/
extension SessionTableViewController: UITableViewDelegate
{
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
      tableView.reloadData() // need to reload to update cell index paths
    }
  }
  
  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

    if let selectedCellIndexPath = selectedCellIndexPath {
      if selectedCellIndexPath == indexPath {
        self.selectedCellIndexPath = nil
      } else {
        self.selectedCellIndexPath = indexPath
      }
    } else {
      selectedCellIndexPath = indexPath
    }
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! LiftDataCell
    (cell as LiftDataCell).didSelect()

    tableView.beginUpdates()
    tableView.endUpdates()
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
    let (repCount, weight) = CDSetHelper().getPRforLift(setsArray![indexPath.row][0].movementType!)
    
    cell!.delegate = self
    cell!.indexPath = indexPath
    cell!.liftName.text = setsArray![indexPath.row][0].movementType
    if (weight - floor(weight) > 0.000001) { // 0.000001 can be changed depending on the level of precision you need
      cell!.currentPR.text = "\(repCount) x \(weight) lbs"
    } else {
      cell!.currentPR.text = "\(repCount) x \(Int(weight)) lbs"
    }
    

    // configure the set Stack
    cell!.newPRStack.hidden = true
    cell!.clearSetStack()
    for (index, set) in setsArray![indexPath.row].enumerate() {
      if set != setsArray![indexPath.row].last && setsArray![indexPath.row].count > 1{
        let startDate = set.date
        let endDate = setsArray![indexPath.row][index + 1].date
        let restPeriod = endDate?.timeIntervalSinceDate(startDate!)
        let restPeriodString = stringFromTimeInterval(restPeriod!)

        cell!.addSetToStack(index + 1, repCount: Int(set.repCount!), weight: Double(set.weight!), rest: restPeriodString)
      } else {
          cell!.addSetToStack(index + 1, repCount: Int(set.repCount!), weight: Double(set.weight!), rest: nil)
      }
      
      if let didSetPR = set.didSetPRBool{
        if didSetPR == true { cell!.newPRStack.hidden = false }
      }
    }
    
    cell!.insetView.layer.cornerRadius = 20
    cell!.insetView.clipsToBounds = true
    cell!.backgroundColor = PRIMARY_COLOR
    
    CDMovementHelper().getMuscleGroupForLift(setsArray![indexPath.row][0].movementType!)
    return cell!
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return setsArray != nil ? setsArray!.count : 0
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let sets = setsArray![indexPath.row].count
    
    // Expanded height
    if let selectedCellIndexPath = selectedCellIndexPath {
      if selectedCellIndexPath == indexPath {
        let linesHeight = sets * 63
        let height = CGFloat(linesHeight + 107)
        return height
      }
    }

    let linesHeight = sets * 20
    let height = CGFloat(linesHeight + 107)
    return height
  }
  
  /****************************************************************************
   *
   *****************************************************************************/
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

/****************************************************************************
 *
 *****************************************************************************/
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
    
    presentViewController(menu, animated: true, completion: nil)
    setViewAlpha(0.5)
    removeNavBarTapRecognizer()
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
  
  /****************************************************************************
   *
   *****************************************************************************/
  func editLiftPressed(indexPath: NSIndexPath) {
    selectedIndexPath = indexPath
		editLift()
  }
}

/**************************************************************************
 *
 ***************************************************************************/
extension SessionTableViewController: AddLiftQuickDelegate
{
  func didDismissPopover() {
    setViewAlpha(1)
    addNavBarTapRecognizer()
  }
  
  func addedSet() {
    setViewAlpha(1)
    (session, setsArray) = CDSessionHelper().getSession(sessionId!)
		myTableView.reloadData()
    resetTimer()
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
    addNavBarTapRecognizer()
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
		addLift()
    setViewAlpha(1)
  }
}

/**************************************************************************
 *
 ***************************************************************************/
extension SessionTableViewController: LiftDelegate
{
  func didSaveSet(sessionId:NSManagedObjectID) {
    self.sessionId = sessionId
    skipViewDidAppear = true
    configureView()
		resetTimer()
  }
  
  func didDeleteSession() {
    self.sessionId = nil
    configureView()
  }
  
  func didCancel() {
    skipViewDidAppear = true
  }
}

extension SessionTableViewController: EmptySessionDelegate
{
  func didPressAddSet() {
    addLift()
  }
}