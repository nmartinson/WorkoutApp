//
//  CreateChartDataHelper.swift
//  ChartIntro
//
//  Created by Nick on 9/25/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import Charts

class CreateChartDataHelper: NSObject
{
  
  /* *************************************************************************
  *
  ***************************************************************************/
  func createBarChartData(label: String, xVals: [NSObject], yVals: [NSObject]) -> BarChartData
  {
    var xVals:[NSObject] = []
    for(var i = 0; i < 10; i++)
    {
      xVals.append(i)
    }
    var yVals :[BarChartDataEntry] = []
    
    for(var i = 0; i < 10; i++)
    {
      let entry = BarChartDataEntry(value: 20.0, xIndex: i)
      yVals.append(entry)
    }
    
    let set1 = BarChartDataSet(yVals: yVals, label: label)
    
    let dataSets = NSMutableArray()
    dataSets.addObject(set1)
    
    let data = BarChartData(xVals: xVals, dataSet: set1)
    return data
  }
  
  
  /* *************************************************************************
  *
  ***************************************************************************/
  func createChartData(label: String) -> ChartData
  {
    var xVals:[NSObject] = []
    for(var i = 0; i < 10; i++)
    {
      xVals.append(i)
    }
    var yVals :[ChartDataEntry] = []
    
    for(var i = 0; i < 10; i++)
    {
      let entry = ChartDataEntry(value: 20.0, xIndex: i)
      yVals.append(entry)
    }
    
    let set1 = ChartDataSet(yVals: yVals, label: label)
    
    let dataSets = NSMutableArray()
    dataSets.addObject(set1)
    
    let data = ChartData(xVals: xVals, dataSet: set1)
    return data
  }
  
  /* *************************************************************************
  *
  ***************************************************************************/
  func createMultipleBarChart(lifts: [[SetEntity]]) -> BarChartData
  {
    var xVals:[NSObject] = []
    
    for(var i = 0; i < lifts.count; i++)
    {
      let formatter = NSDateFormatter()
      formatter.dateStyle = .ShortStyle
      let dateString = formatter.stringFromDate(lifts[i][0].date!)
      
      xVals.append(dateString)
    }
    
    var yVals :[BarChartDataEntry] = []
    
    var index = 0
    for session in lifts
    {
      var maxSet = session[0]
      for(var i = 0; i < session.count; i++)
      {
        let val = Double(session[i].weight!)
        if val > Double(maxSet.weight!)
        {
          maxSet = session[i]
        }
      }
      
      let entry = BarChartDataEntry(value: Double(maxSet.weight!), xIndex: index)
      yVals.append(entry)
      index++
      
    }
    let set = BarChartDataSet(yVals: yVals, label: "Weight")
    let data = BarChartData(xVals: xVals, dataSet: set)
    
    return data
  }
  
  /* *************************************************************************
  *
  ***************************************************************************/
  func createLiftHistoryDummyChart() -> BarChartData
  {
    var xVals:[NSObject] = []
    
    for(var i = 0; i < 20; i++)
    {
      
      xVals.append(i)
    }
    
    var yVals :[BarChartDataEntry] = []
    
    for(var i = 0; i < 20; i++)
    {
      let val = Double(arc4random_uniform(30))
      let entry = BarChartDataEntry(value: val, xIndex: i)
      yVals.append(entry)
      
    }
    let set = BarChartDataSet(yVals: yVals, label: "")
    set.drawValuesEnabled = false
    let data = BarChartData(xVals: xVals, dataSet: set)
    
    return data
  }
  
  /* *************************************************************************
  *
  ***************************************************************************/
  func createLiftFrequencyDummyChart() -> PieChartData
  {
    var xVals:[NSObject] = []

    for(var i = 0; i < 10; i++)
    {
      xVals.append("")
    }
    var yVals :[BarChartDataEntry] = []
    
    for(var i = 0; i < 10; i++)
    {
      let val = Double(arc4random_uniform(30))
      let entry = BarChartDataEntry(value: val, xIndex: i)
      yVals.append(entry)
    }
    
    let set1 = PieChartDataSet(yVals: yVals, label: "Lift Frequency")
    set1.drawValuesEnabled = false

    let dataSets = NSMutableArray()
    dataSets.addObject(set1)

    
    let data = PieChartData(xVals: xVals, dataSet: set1)
    
    var colors:[UIColor] = []
    colors.append(ChartColorTemplates.joyful().first!)
    colors.append(ChartColorTemplates.colorful().first!)
    colors.append(ChartColorTemplates.pastel().first!)
    set1.colors = colors
  
    return data
  }
  
  
  /* *************************************************************************
  *	Creates a Pie chart data of lift frequency with frequency in percent
  *	return: PieChartData
  ***************************************************************************/
  func createPieChartDataForLiftFrequency(liftDict:Dictionary<String,Int>?, sum:Int) -> PieChartData
  {
    var xVals:[NSObject] = []
    let keys = [String](liftDict!.keys)
    for(var i = 0; i < keys.count; i++)
    {
      xVals.append(keys[i])
    }
    var yVals :[BarChartDataEntry] = []
    
    for(var i = 0; i < keys.count; i++)
    {
      let key = keys[i]
      let val = Double(liftDict![key]!)/Double(sum) * 100
      let entry = BarChartDataEntry(value: val, xIndex: i)
      yVals.append(entry)
    }
    
    let set1 = PieChartDataSet(yVals: yVals, label: "Lift Frequency")
    
    let dataSets = NSMutableArray()
    dataSets.addObject(set1)
    
    let data = PieChartData(xVals: xVals, dataSet: set1)
    
    var colors:[UIColor] = []
    //        colors.append(ChartColorTemplates.vordiplom().first!)
    colors.append(ChartColorTemplates.joyful().first!)
    colors.append(ChartColorTemplates.colorful().first!)
    //        colors.append(ChartColorTemplates.liberty().first!)
    colors.append(ChartColorTemplates.pastel().first!)
    set1.colors = colors
    
    
    let pFormatter = NSNumberFormatter()
    pFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
    pFormatter.maximumFractionDigits = 1
    pFormatter.multiplier = 1.0
    pFormatter.percentSymbol = " %"
    data.setValueFormatter(pFormatter)
    return data
  }
}