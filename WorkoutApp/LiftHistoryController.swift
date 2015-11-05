//
//  LiftHistoryController.swift
//  WorkoutApp
//
//  Created by Nick on 10/6/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import Charts

class LiftHistoryController: UIViewController, ChartViewDelegate
{
    @IBOutlet weak var chart: BarChartView!
    var liftString:String?
    
    /* *************************************************************************
    *
    ***************************************************************************/
    override func viewDidLoad()
    {
        self.view.backgroundColor = PRIMARY_COLOR
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")

        let lifts = CDSessionHelper().getLiftStats(liftString!)
        let data = CreateChartDataHelper().createMultipleBarChart(lifts!)
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1.0), font: UIFont.systemFontOfSize(12.0), insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))
        chart.marker = marker
        chart.rightAxis.enabled = false
        chart.delegate = self
        chart.drawBarShadowEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.backgroundColor = PRIMARY_COLOR
		chart.xAxis.labelTextColor = UIColor.whiteColor()
        chart.leftAxis.labelTextColor = UIColor.whiteColor()
        chart.descriptionText = ""
        let xAxis = chart.xAxis
        xAxis.labelPosition = .Bottom
	
        let leftAxis = chart.leftAxis
        leftAxis.labelPosition = .OutsideChart
		let legend = chart.legend
        legend.textColor = PRIMARY_COLOR
        
        chart.data = data
    }
    
    @IBAction func swipedRight(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    /* *************************************************************************
    *
    ***************************************************************************/
    func backButtonPressed(sender:UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}