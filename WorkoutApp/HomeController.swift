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

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WCSessionDelegate
{
    @IBOutlet weak var myCollectionView: UICollectionView!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var overViewSet = Set<String>()
    var workoutDataArray:[SetEntity] = []
    var workoutSession:SessionEntity?
    let session = WCSession.defaultSession()
    
    /**************************************************************************
     @IBOutlet var resultLabel: WKInterfaceLabel!
    *
    ***************************************************************************/
    override func viewDidLoad() {
		session.delegate = self
        session.activateSession()

        self.view.backgroundColor = PRIMARY_COLOR

    }
    
    
    /**************************************************************************
     *
     ***************************************************************************/
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        if let sessionData = message["sessionData"] as? [String: AnyObject]
        {
            let workoutStartDate = sessionData["workoutStartDate"] as! NSDate
            let workoutDuration = sessionData["workoutDuration"] as! Float
            workoutSession = NSEntityDescription.insertNewObjectForEntityForName("SessionEntity", inManagedObjectContext: appDel.managedObjectContext) as? SessionEntity
			
            workoutSession?.duration = workoutDuration
            workoutSession?.date = workoutStartDate
            
        }
        else if let workoutData = message["workoutData"] as? [String: AnyObject]
        {   
            let movementType = workoutData["movementType"] as! String
            let repCount = workoutData["repCount"] as! Int
            let duration = workoutData["duration"] as! Float
            let meanRepTime = workoutData["meanRepTime"] as! Float
            let minRepTime = workoutData["minRepTime"] as! Float
            let maxRepTime = workoutData["maxRepTime"] as! Float
            let internalVariation = workoutData["internalVariation"] as! Float
            let lastLift = workoutData["lastLift"] as! Bool
            
            let set = NSEntityDescription.insertNewObjectForEntityForName("SetEntity", inManagedObjectContext: appDel.managedObjectContext) as! SetEntity
            set.weight = 0
            set.movementType = movementType
            set.repCount = repCount
            set.duration = duration
            set.meanRepTime = meanRepTime
            set.minRepTime = minRepTime
            set.maxRepTime = maxRepTime
            set.internalVariation = internalVariation
            set.date = NSDate()
            set.session = workoutSession
            overViewSet.insert(set.movementType!)
			workoutDataArray.append(set)
            
            if(lastLift == true){
                workoutSession?.overView = overViewSet.joinWithSeparator(",")
                appDel.saveContext()
                overViewSet.removeAll()
                workoutDataArray.removeAll()
                workoutSession = nil
            }
        }
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
                let (liftDict, sum) = CDSessionHelper().getLiftFrequency()
                let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(liftDict, sum: sum)
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
            
            	for set in ((cell as! LiftFrequencyCell).pieChart.data?.dataSets)!
                {
                 	set.drawValuesEnabled = false
            	}
                
            	(cell as! LiftFrequencyCell).pieChart.spin(duration: 5.0, fromAngle: 0, toAngle: 360, easingOption: .EaseOutBack)
            case 1:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("SessionCell", forIndexPath: indexPath)
            case 2:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryCell", forIndexPath: indexPath) as! LiftHistoryCell
                (cell as! LiftHistoryCell).chart.data = CreateChartDataHelper().createLiftHistoryChart()
            
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
            
            default:
                print("Error")
        }

        return cell!
    }
    
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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