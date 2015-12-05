//
//  CalendarController.swift
//  WorkoutApp
//
//  Created by Nick on 11/16/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import CoreData

/**************************************************************************
 *
 ***************************************************************************/
extension CalendarController: UIPopoverPresentationControllerDelegate
{
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
  
}

extension CalendarController: CalendarMenuDelegate
{
  func didSelectWorkout(sessionID: NSManagedObjectID) {
    menu?.dismissViewControllerAnimated(true, completion: nil)
    performSegueWithIdentifier("toSession", sender: self)
  }
}


/**************************************************************************
 *
 ***************************************************************************/
class CalendarController: UIViewController
{
  @IBOutlet weak var calendar: FSCalendar!
  
  var touchLocation:CGPoint?
  var sessions:[SessionEntity] = []
  var selectedIndex:Int? = 0
  var workoutsPerDay = 0
  var selectedDate:NSDate?
  var skipViewDidAppear = true
  var menu:CalendarMenuControllerViewController?
  
  override func viewDidLoad() {
    self.view.backgroundColor = PRIMARY_COLOR
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")
    skipViewDidAppear = true
    selectedDate = NSDate()
		configureCalendar()
  }
  
  override func viewDidAppear(animated: Bool) {
    if !skipViewDidAppear {
      configureCalendar()
    }
    skipViewDidAppear = false
  }
  
  func backButtonPressed(sender:UIButton) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func configureCalendar() {
    self.sessions = CDSessionHelper().getSessions()
    calendar.backgroundColor = PRIMARY_COLOR
    calendar.scrollDirection = .Vertical
    calendar.appearance.caseOptions = [.HeaderUsesUpperCase,.WeekdayUsesUpperCase]
    calendar.selectDate(selectedDate)
    calendar.reloadData()
  }
  
  @IBAction func goToToday(sender: AnyObject) {
    calendar.selectDate(NSDate())
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == "toSession" {
      let vc = segue.destinationViewController as! SessionTableViewController
      vc.selectedDate = selectedDate!
      if let selectedIndex = selectedIndex {
	      vc.sessionId = sessions[selectedIndex].objectID
      }
    }
  }
  
  func showMultipleWorkoutsView(){
    menu = CalendarMenuControllerViewController()
    menu!.delegate = self
    let sessionsToSend = Array(sessions[selectedIndex!..<selectedIndex! + workoutsPerDay])
    menu!.modalPresentationStyle = .Popover
    menu!.preferredContentSize = CGSize(width: 300, height: 110)
    
    let popoverMenuViewController = menu!.popoverPresentationController
    popoverMenuViewController?.permittedArrowDirections = .Any
    popoverMenuViewController?.delegate = self
    popoverMenuViewController?.sourceView = self.view
    popoverMenuViewController?.sourceRect = CGRect(
      x: touchLocation!.x,
      y: touchLocation!.y - 300,
      width: 1,
      height: 1)
    presentViewController(menu!, animated: true, completion: nil)
    menu!.setWorkoutData(sessionsToSend)

  }
  
  

}
/**************************************************************************
 *
 ***************************************************************************/
extension CalendarController: FSCalendarDataSource
{
  func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
    for session in sessions {
      if session.date?.fs_dateByIgnoringTimeComponents == date.fs_dateByIgnoringTimeComponents {
        calendar.eventColor = UIColor.orangeColor()
				calendar.appearance.cellShape = .Circle
        return true
      }
    }
    return false
  }
  
  func calendar(calendar: FSCalendar!, imageForDate date: NSDate!) -> UIImage! {
    for session in sessions {
      if session.date == date {
        if Int(session.duration!) > 60 {
          return UIImage(named: "workout_complete.png")
        } else if Int(session.duration!) < 60 && Int(session.duration!) > 30 {
          return UIImage(named: "workout_average.png")
        } else if Int(session.duration!) > 1 {
          return UIImage(named: "workout_low.png")
        }
      }
    }
    return nil
  }
  
}

/**************************************************************************
 *
 ***************************************************************************/
extension CalendarController: FSCalendarDelegate
{
  func calendarCurrentPageDidChange(calendar: FSCalendar!) {
  }
  
  func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
    
  }
  
  func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!, locationFrame: CGRect) {
    workoutsPerDay = 0
    selectedDate = date
    let x = locationFrame.origin.x
    let y = locationFrame.origin.y % 1000
    touchLocation = CGPoint(x: x, y: y)
    
    for (index, session) in sessions.enumerate() where session.date!.fs_dateByIgnoringTimeComponents == date.fs_dateByIgnoringTimeComponents{
      workoutsPerDay++
      selectedIndex = index
    }

    if workoutsPerDay == 0 {
      selectedIndex = nil
      performSegueWithIdentifier("toSession", sender: self)
    } else if workoutsPerDay == 1 {
      performSegueWithIdentifier("toSession", sender: self)
    } else if workoutsPerDay > 1 {
      selectedIndex = selectedIndex! - workoutsPerDay + 1
      showMultipleWorkoutsView()
    }
  }
  
}






