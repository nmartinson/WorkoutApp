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
    
    override func viewDidLoad()
    {
        let lifts = CDSessionHelper().getLiftStats(liftString!)
        let data = CreateChartDataHelper().createMultipleBarChart(lifts!)
        
        chart.delegate = self
        
        chart.noDataTextDescription = "NO DATA"
        let xAxis = chart.xAxis
        xAxis.labelPosition = .Bottom
	
        let leftAxis = chart.leftAxis
        leftAxis.labelPosition = .OutsideChart

        
        chart.data = data
    }
    
    
}