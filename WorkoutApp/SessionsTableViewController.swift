//
//  SessionsTableViewController.swift
//  WorkoutApp
//
//  Created by Nick on 10/4/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit


//extension SessionsTableViewController: DZNEmptyDataSetDelegate
//{
//  
//}
//
//extension SessionsTableViewController: DZNEmptyDataSetSource
//{
//  func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//    return UIImage(named: "placeholder.png")
//  }
//  
////  func imageAnimationForEmptyDataSet(scrollView: UIScrollView!) -> CAAnimation! {
////    let animation = CABasicAnimation(keyPath: "transform")
////    animation.fromValue = NSValue
////  }
//  
//  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//    let text = "Go workout so you have some data to look at!"
//    let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.whiteColor()]
//    
//    return NSAttributedString(string: text, attributes: attributes)
//  }
//  
//  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//    let text = "Once you workout, your sessions will show "
//    let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.whiteColor()]
//    
//    return NSAttributedString(string: text, attributes: attributes)
//  }
//}

class SessionsTableViewController: UIViewController
{
  
  @IBOutlet weak var myTableView: UITableView!
  var sessions:[SessionEntity] = []
  var selectedIndexPath:NSIndexPath?
  
  /**************************************************************************
   *
   ***************************************************************************/
  override func viewDidLoad()
  {
    self.title = "Sessions"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")
    self.view.backgroundColor = PRIMARY_COLOR
    self.sessions = CDSessionHelper().getSessions()
//    myTableView.emptyDataSetDelegate = self
//    myTableView.emptyDataSetSource = self
    myTableView.reloadData()
  }
  
  @IBAction func swipedRight(sender: AnyObject)
  {
    navigationController?.popViewControllerAnimated(true)
  }
  
  override func viewDidAppear(animated: Bool) {
    if selectedIndexPath != nil {
      myTableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
    }
  }
  
  func backButtonPressed(sender:UIButton) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  
  /**************************************************************************
   *
   ***************************************************************************/
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    let vc = segue.destinationViewController as! SessionTableViewController
    vc.sessionId = sessions[selectedIndexPath!.row].objectID
  }
  
}


/**************************************************************************
 *	MARK: UITableViewDataSource
 ***************************************************************************/
extension SessionsTableViewController: UITableViewDataSource
{
  /**************************************************************************
   *
   ***************************************************************************/
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("sessionCell")
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    let dateString = formatter.stringFromDate(sessions[indexPath.row].date!)
    cell?.textLabel?.textColor = UIColor.whiteColor()
    cell?.textLabel?.text = dateString
    return cell!
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sessions.count
  }
}

/**************************************************************************
 *	MARK: UITableViewDelegate
 ***************************************************************************/
extension SessionsTableViewController: UITableViewDelegate
{
  /**************************************************************************
   *
   ***************************************************************************/
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    selectedIndexPath = indexPath
    performSegueWithIdentifier("toSession", sender: self)
  }
}