//
//  ViewController.swift
//  WorkoutApp
//
//  Created by Nick on 10/1/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        
        let liftDict = CDSessionHelper().getLiftFrequency()
        let data = CreateChartDataHelper().createPieChartDataForLiftFrequency(liftDict)
        pieChart.data = data
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

