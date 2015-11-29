//
//  TrainingController.swift
//  WorkoutApp
//
//  Created by Nick on 11/9/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

extension TrainingController
{
  func didReceiveTrainData(notification: NSNotification)
  {
    let trainData = notification.userInfo
    repCount = trainData!["repCount"] as? Int
    if let movementType = trainData!["movementType"] as? String
    {
      if movementType != self.movementType
      {
        self.movementType = movementType
        trainer = FmAnalyzerTrainer.init(movementType)

      }
    }
    liftLabel.setText(movementType!)
    repsLabel.setText("\(repCount!)")
  }
}

class TrainingController:WKInterfaceController, FmLocalDeviceDelegate
{
  @IBOutlet var liftLabel: WKInterfaceLabel!
  @IBOutlet var repsLabel: WKInterfaceLabel!
  @IBOutlet var traingSwitch: WKInterfaceSwitch!
  @IBOutlet var trainButton: WKInterfaceButton!
  @IBOutlet var resultLabel: WKInterfaceLabel!
  
  var trainer:FmAnalyzerTrainer?
  var output:FmDeviceOutput?
  var repCount:Int?
  var movementType:String? = ""
  
  /**************************************************************************
   *
   ***************************************************************************/
  override func awakeWithContext(context: AnyObject?)
  {
    self.setTitle("Trainer")
    trainButton.setEnabled(false)
    FmLocalDevice.instance().deviceDelegate = self
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveTrainData:", name: "trainData", object: nil)

  }
  

  
  /**************************************************************************
   *
   ***************************************************************************/
  func analyze()
  {
    let analyzer = FmMovementAnalyzer.newTrainedSingleMovementAnalyzer(movementType)
    analyzer.analyze(output)
//    FmMovementAnalyzer.writeIdealFile(movementType, path: <#T##String!#>, pathType: kFmPathType_WriteDefault, data: trainer.)
    
    print("NUM RESULTS: \(analyzer.numResults)")
    print("MOVEMENT: \(movementType)")
    if analyzer.numResults > 0
    {
      let result = analyzer.resultAtIndex(0)
      let resultText = "Type: \(result.movementType)\n"
      "Reps: \(result.repCount)\n"
      "Duration: \(result.duration)"
      
      resultLabel.setText(resultText)
    }
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func recordingChanged(device: FmLocalDevice!, recording: Bool)
  {
    if !recording
    {
      output = FmLocalDevice.instance().output
      trainer!.addTrainingDataSet(output, repCount: Int32(repCount!))
//      kFmPathType_WriteDefault
    }
    updateTrainButton()
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  func updateTrainButton()
  {
    trainButton.setEnabled(output != nil)
  }
  
  // MARK: - Actions
  
  /**************************************************************************
  *
  ***************************************************************************/
  @IBAction func trainPressed()
  {
//    trainer!.addTrainingDataSet(output, repCount: Int32(repCount!))
    trainer!.train()
    analyze()
    print("ANALYZE DONE")
    output = nil
    repCount = nil
    movementType = nil
  }
  
  /**************************************************************************
   *
   ***************************************************************************/
  @IBAction func startPressed(value: Bool)
  {
    let device = FmLocalDevice.instance()
    if device.recording {
      device.stopRecording()
    } else {
      device.startRecording()
    }
    traingSwitch.setTitle(FmLocalDevice.instance().recording ? "Stop" : "Start")
  }
}