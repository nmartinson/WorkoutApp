//
//  HomeController.swift
//  WorkoutApp
//
//  Created by Nick on 10/5/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity
import CoreData

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
  @IBOutlet weak var myCollectionView: UICollectionView!

  
  /**************************************************************************
  @IBOutlet var resultLabel: WKInterfaceLabel!
  *
  ***************************************************************************/
  override func viewDidLoad() {
    self.view.backgroundColor = PRIMARY_COLOR
  }
  
  func session(session: WCSession, didReceiveFile file: WCSessionFile) {
    print("GOT FILE")
    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let docsDir = dirPaths[0] as String
    let filemgr = NSFileManager.defaultManager()
    let path = docsDir.stringByAppendingString("/accel.txt")
    
    do{
      try filemgr.removeItemAtPath(path)
    } catch {
      
    }
    
    do {
      try filemgr.moveItemAtPath(file.fileURL.path!, toPath: docsDir + "/accel.txt")
    } catch let error as NSError {
      print("Error moving file: \(error.description)")
    }
    let data = NSData(contentsOfURL: NSURL(fileURLWithPath: docsDir.stringByAppendingString("/accel.txt")) )
    let datastring = NSString(data: data!, encoding:NSUTF8StringEncoding)
    print(datastring)
  }

  
  /**************************************************************************
   *
   ***************************************************************************/
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 10
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 10
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: 150, height: 150)
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell:UICollectionViewCell!
    
    switch indexPath.item
    {
    case 0:
      cell = collectionView.dequeueReusableCellWithReuseIdentifier("FrequencyCell", forIndexPath: indexPath) as! LiftFrequencyCell
      let data = CreateChartDataHelper().createLiftFrequencyDummyChart()
      (cell as! LiftFrequencyCell).pieChart.data = data
      (cell as! LiftFrequencyCell).pieChart.holeRadiusPercent = 0.58
      (cell as! LiftFrequencyCell).pieChart.transparentCircleRadiusPercent = 0.61
      (cell as! LiftFrequencyCell).pieChart.drawHoleEnabled = true
      (cell as! LiftFrequencyCell).pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .EaseOutBack)
      (cell as! LiftFrequencyCell).pieChart.drawCenterTextEnabled = false
      (cell as! LiftFrequencyCell).pieChart.holeColor = PRIMARY_COLOR
      (cell as! LiftFrequencyCell).pieChart.descriptionText = ""
      (cell as! LiftFrequencyCell).pieChart.legend.enabled = false
      (cell as! LiftFrequencyCell).pieChart.drawSliceTextEnabled = false
      (cell as! LiftFrequencyCell).pieChart.backgroundColor = PRIMARY_COLOR
      (cell as! LiftFrequencyCell).pieChart.spin(duration: 5.0, fromAngle: 0, toAngle: 360, easingOption: .EaseOutBack)
    case 1:
      cell = collectionView.dequeueReusableCellWithReuseIdentifier("SessionCell", forIndexPath: indexPath)
    case 2:
      cell = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryCell", forIndexPath: indexPath) as! LiftHistoryCell
      (cell as! LiftHistoryCell).chart.data = CreateChartDataHelper().createLiftHistoryDummyChart()
      
      (cell as! LiftHistoryCell).chart.rightAxis.enabled = false
      (cell as! LiftHistoryCell).chart.drawGridBackgroundEnabled = false
      (cell as! LiftHistoryCell).chart.drawValueAboveBarEnabled = false
      (cell as! LiftHistoryCell).chart.leftAxis.enabled = false
      (cell as! LiftHistoryCell).chart.xAxis.enabled = false
      (cell as! LiftHistoryCell).chart.drawBarShadowEnabled = false
      (cell as! LiftHistoryCell).chart.drawGridBackgroundEnabled = false
      (cell as! LiftHistoryCell).chart.backgroundColor = PRIMARY_COLOR
      (cell as! LiftHistoryCell).chart.xAxis.labelTextColor = UIColor.whiteColor()
      (cell as! LiftHistoryCell).chart.leftAxis.labelTextColor = UIColor.whiteColor()
      (cell as! LiftHistoryCell).chart.descriptionText = ""
      let xAxis = (cell as! LiftHistoryCell).chart.xAxis
      xAxis.labelPosition = .Bottom
      
      let leftAxis = (cell as! LiftHistoryCell).chart.leftAxis
      leftAxis.labelPosition = .OutsideChart
      (cell as! LiftHistoryCell).chart.legend.enabled = false
      (cell as! LiftHistoryCell).chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    case 3:
      cell = collectionView.dequeueReusableCellWithReuseIdentifier("TrainerCell", forIndexPath: indexPath)
    default:
      print("Error")
    }
    
    return cell!
  }
  
  
  /**************************************************************************
   *
   ***************************************************************************/
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  
}