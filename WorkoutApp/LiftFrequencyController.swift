//
//  ViewController.swift
//  WorkoutApp
//
//  Created by Nick on 10/1/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import Charts

class LiftFrequencyController: UIViewController, ChartViewDelegate {
  
  @IBOutlet weak var pieChart: PieChartView!
  var emptySetView:UIView?
  var muscleGroupData = Dictionary<String,(Dictionary<String,Int>?, Int)>()
  
  /* *************************************************************************
  *
  ***************************************************************************/
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.title = "Lift Frequency"
    self.view.backgroundColor = PRIMARY_COLOR
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")
    
    pieChart.delegate = self
    
//    let (liftDict, sum) = CDSessionHelper().getLiftFrequency()
    muscleGroupData = CDSessionHelper().getLiftFrequencyByMuscleGroup()
    let (groupDict, groupSum) = muscleGroupData[MuscleGroup.Groups.rawValue]!
    
    if groupSum > 0 {
      let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(groupDict, sum: groupSum)
      pieChart.data = data
      //        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1.0), font: UIFont.systemFontOfSize(12.0), insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))
      //
      //        pieChart.marker = marker
      //        pieChart.holeTransparent = true
      pieChart.holeRadiusPercent = 0.58
      pieChart.transparentCircleRadiusPercent = 0.61
      pieChart.drawHoleEnabled = true
      pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .EaseOutBack)
      pieChart.drawCenterTextEnabled = true
      pieChart.holeColor = PRIMARY_COLOR
      pieChart.descriptionText = ""
      let legend = pieChart.legend
      legend.textColor = UIColor.whiteColor()
      legend.position = .LeftOfChart
    } else {
      // display empty set
      emptySetView = NSBundle.mainBundle().loadNibNamed("EmptyDataView", owner: nil, options: nil)[0] as? UIView
      emptySetView!.frame = view.frame
      emptySetView!.backgroundColor = PRIMARY_COLOR
      pieChart.hidden = true
			self.view.addSubview(emptySetView!)
    }
    
  }
  
  @IBAction func shouldersPressed(sender: AnyObject) {
    let (shouldersDict, shouldersSum) = muscleGroupData[MuscleGroup.Shoulders.rawValue]!
		let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(shouldersDict, sum: shouldersSum)
    pieChart.data = data
  }
  
  @IBAction func lowerBodyPressed(sender: AnyObject) {
    let (lowerDict, lowerSum) = muscleGroupData[MuscleGroup.Lower.rawValue]!
    let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(lowerDict, sum: lowerSum)
    pieChart.data = data
  }
  
  @IBAction func corePressed(sender: AnyObject) {
    let (coreDict, coreSum) = muscleGroupData[MuscleGroup.Core.rawValue]!
    let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(coreDict, sum: coreSum)
    pieChart.data = data
  }
  
  @IBAction func armsPressed(sender: AnyObject) {
    let (armsDict, armsSum) = muscleGroupData[MuscleGroup.Arms.rawValue]!
    let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(armsDict, sum: armsSum)
    pieChart.data = data
  }
  
  @IBAction func chestPressed(sender: AnyObject) {
    let (chestDict, chestSum) = muscleGroupData[MuscleGroup.Chest.rawValue]!
    let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(chestDict, sum: chestSum)
    pieChart.data = data
  }
  
  @IBAction func backPressed(sender: AnyObject) {
    let (backDict, backSum) = muscleGroupData[MuscleGroup.Back.rawValue]!
    let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(backDict, sum: backSum)
    pieChart.data = data
  }
  
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    if emptySetView != nil {
      emptySetView?.frame = view.frame
    }
  }
  

  
  /* *************************************************************************
  *
  ***************************************************************************/
  func backButtonPressed(sender:UIButton)
  {
    navigationController?.popViewControllerAnimated(true)
  }
  
}

