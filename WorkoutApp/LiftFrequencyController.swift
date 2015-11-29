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
    
    let (liftDict, sum) = CDSessionHelper().getLiftFrequency()
    
    if sum > 0 {
      let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(liftDict, sum: sum)
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
  
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    if emptySetView != nil {
      emptySetView?.frame = view.frame
    }
  }
  
  
  @IBAction func swipedRight(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  /* *************************************************************************
  *
  ***************************************************************************/
  func backButtonPressed(sender:UIButton)
  {
    navigationController?.popViewControllerAnimated(true)
  }
  
}

