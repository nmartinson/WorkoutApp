//
//  WorkoutController.swift
//  FocusMotionTesting
//
//  Created by Nick Martinson on 9/20/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit
import CoreMotion

struct Platform {
  static let isSimulator: Bool = {
    var isSim = false
    #if arch(i386) || arch(x86_64)
      isSim = true
    #endif
    return isSim
  }()
}

protocol WorkoutSessionManagerDelegate: class {
  func workoutSessionManager(workoutController: WorkoutController, didStartWorkoutWithDate startDate: NSDate)
  func workoutSessionManager(workoutController: WorkoutController, didStopWorkoutWithDate endDate: NSDate)
  func workoutSessionManager(workoutController: WorkoutController, didUpdateActiveEnergyQuantity activeEnergyQuantity: HKQuantity)
  func workoutSessionManager(workoutController: WorkoutController, didUpdateBasalEnergyQuantity basalEnergyQuantity: HKQuantity)
  func workoutSessionManager(workoutController: WorkoutController, didUpdateHeartRateSample heartRateSample: HKQuantitySample)
}

extension WorkoutController: FmLocalDeviceDelegate
{
  /**********************************************************************
   *
   **********************************************************************/
  func recordingChanged(device: FmLocalDevice!, recording: Bool) {
    if(!recording){
      analyze { (success) -> Void in
        if success == true
        {
          var context:[String:AnyObject] = Dictionary<String,AnyObject>()
          context["sessionStartDate"] = self.workoutStartDate!
          context["sessionEndDate"] = self.workoutEndDate!
          context["sessionDuration"] = NSDate().timeIntervalSinceDate(self.workoutStartDate!)
          context["setData"] = self.setData
          WKInterfaceController.reloadRootControllers([(name: "Summary", context: context)])
        } else {
          self.label.setText("Error analyzing")
          WKInterfaceController.reloadRootControllers([(name: "Summary", context: [])])
        }
      }
    }
  }
}

extension WorkoutController: HKWorkoutSessionDelegate
{
  /**********************************************************************
   *
   **********************************************************************/
  func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
    dispatch_async(dispatch_get_main_queue()) {
      switch toState {
      case .Running:
        self.workoutDidStart(date)
      case .Ended:
        self.workoutDidEnd(date)
      default:
        print("Unexpected workout session state \(toState)")
      }
    }
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
  }
  
}


class WorkoutController: WKInterfaceController, WCSessionDelegate
{
  @IBOutlet var heart: WKInterfaceImage!
  @IBOutlet var label: WKInterfaceLabel!
  @IBOutlet var resultLabel: WKInterfaceLabel!
  @IBOutlet var timerLabel: WKInterfaceTimer!
  @IBOutlet var recordSwitch: WKInterfaceSwitch!
  @IBOutlet var calVal: WKInterfaceLabel!
  var workouts:[HKWorkout] = []
  let session = WCSession.defaultSession()
  let healthStore: HKHealthStore = HKHealthStore()
  var workoutSession: HKWorkoutSession?
  var workoutStartDate: NSDate?
  var workoutEndDate: NSDate?
  var queries: [HKQuery] = []
  var activeEnergySamples: [HKQuantitySample] = []
  var heartRateSamples: [HKQuantitySample] = []
  let energyUnit = HKUnit.calorieUnit()
  let heartRateUnit = HKUnit(fromString: "count/min")
  let activeEnergyType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
  let basalEnergyType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalEnergyBurned)
  let heartRateType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
  var paused = false
  var currentActiveEnergyQuantity: HKQuantity?
  var totalActiveEnergyBurned: Double = 0
  var currentHeartRateSample: HKQuantitySample?
  var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
  let formatter = NSNumberFormatter()
  
  var setData:[SetEntity] = []
  var sessionData:[String:AnyObject]?
  
  let filemgr = NSFileManager.defaultManager()
  let dir:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
  var fileurl:NSURL?
  
  let motionManager = CMMotionManager()
  let filter = AccelerometerFilter(rate: 60, cutOffFreq: 5.0)
  
  weak var delegate: WorkoutSessionManagerDelegate?
  
  /**********************************************************************
   *
   **********************************************************************/
  override func awakeWithContext(context: AnyObject?) {
    //        fileurl =  dir.URLByAppendingPathComponent("log.txt")
    //				removeFile()

    FmLocalDevice.instance().deviceDelegate = self
    if HKHealthStore.isHealthDataAvailable() {
      authorizeHealthKit()
    }
    
    // initialize workout session
    self.workoutSession = HKWorkoutSession(activityType: .TraditionalStrengthTraining, locationType: .Indoor)
    self.currentActiveEnergyQuantity = HKQuantity(unit: self.energyUnit, doubleValue: 0.0)
    self.workoutSession!.delegate = self
    
    session.delegate = self
    session.activateSession()
    timerLabel.start()
				workoutStartDate = NSDate()
    
    // configure number formatter
    formatter.numberStyle = .DecimalStyle
    formatter.maximumFractionDigits = 0
    
    self.startWorkout()
    FmLocalDevice.instance().startRecording()
				setupForceMenu()
    
    //        if (motionManager.accelerometerAvailable == true) {
    //            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
    //
    //                let (x,y,z) = self.filter.lowPass(data!)
    //                let string = "\(x), \(y), \(z)\n"
    //                let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    //
    //                if self.filemgr.fileExistsAtPath(self.fileurl!.path!) {
    //                    do {
    //                        let fileHandle = try NSFileHandle(forWritingToURL: self.fileurl!)
    //                        fileHandle.seekToEndOfFile()
    //                        fileHandle.writeData(data)
    //                        fileHandle.closeFile()
    //                    } catch let error as NSError {
    //                        print("Can't open fileHandle \(error)")
    //                    }
    //                }
    //                else {
    //                    if !data.writeToURL(self.fileurl!, atomically: true)
    //                    {
    //                        print("Can't write file")
    //                    }
    //                }
    //            }
    //            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
    //        }
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func setupForceMenu()
  {
    addMenuItemWithItemIcon(.Accept, title: "End", action: Selector("endPressed"))
    addMenuItemWithItemIcon(.Pause, title: "Pause", action: Selector("pausePressed"))
    addMenuItemWithItemIcon(.Decline, title: "Cancel", action: Selector("cancelPressed"))
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func removeFile()
  {
    do {
      try filemgr.removeItemAtURL(fileurl!)
      print("Remove successful")
    } catch let error as NSError{
      print("Remove failed: \(error.localizedDescription)")
    }
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  @IBAction func endPressed()
  {
    motionManager.stopAccelerometerUpdates()
    workoutEndDate = NSDate()
    timerLabel.stop()
    stopWorkoutAndSave()
    FmLocalDevice.instance().stopRecording()
    
    // session.transferFile(fileurl!, metadata: nil)
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  @IBAction func pausePressed()
  {
    if paused
    {
      timerLabel.start()
      clearAllMenuItems()
      addMenuItemWithItemIcon(.Accept, title: "End", action: Selector("endPressed"))
      addMenuItemWithItemIcon(.Pause, title: "Pause", action: Selector("pausePressed"))
      addMenuItemWithItemIcon(.Decline, title: "Cancel", action: nil)
      
    } else {
      timerLabel.stop()
      clearAllMenuItems()
      addMenuItemWithItemIcon(.Accept, title: "End", action: Selector("endPressed"))
      addMenuItemWithItemIcon(.Play, title: "Resume", action: Selector("pausePressed"))
      addMenuItemWithItemIcon(.Decline, title: "Cancel", action: nil)
    }
    paused = !paused
    
  }
  
  
  
  
  /**********************************************************************
   *
   **********************************************************************/
  func analyze(completion: (success: Bool) -> Void)
  {
    let data = FmLocalDevice.instance().output
    let analyzer = FmMovementAnalyzer.newMultipleMovementAnalyzer()
    analyzer.analyze(data)
    
    if Platform.isSimulator
    {
      let simulatorSet = SetEntity()
      simulatorSet.weight = 10
      simulatorSet.movementType = "Push Press"
      simulatorSet.repCount = 5
      simulatorSet.duration = 75
      simulatorSet.meanRepTime = 8
      simulatorSet.minRepTime = 2
      simulatorSet.maxRepTime = 10
      simulatorSet.internalVariation = 5
      setData.append(simulatorSet)
      completion(success: true)
    }
    else
    {
      let count = Int(analyzer.numResults)
      
      if(count > 0)
      {
        for(var i = 0; i < count; i++)
        {
          let result = analyzer.resultAtIndex(Int32(i))
          if(result.movementType != "resting"){
            let set = SetEntity()
            set.weight = 0
            set.movementType = FmGetMovementDisplayNameString(result.movementType)
            set.repCount = NSNumber(int: result.repCount)
            set.duration = result.duration
            set.meanRepTime = result.meanRepTime
            set.minRepTime = result.minRepTime
            set.maxRepTime = result.maxRepTime
            set.internalVariation = result.internalVariation
            setData.append(set)
          }
        }
        completion(success: true)
      }
      else { completion(success: false) }
    }
  }
  
  
  /**********************************************************************
   *
   **********************************************************************/
  private func addHeartRateSamples(samples: [HKSample]?)
  {
    guard let samples = samples as? [HKQuantitySample] else { return }
    guard let quantity = samples.last?.quantity else { return }
    self.heartRateSamples.append(samples.last!)
    self.label.setText(formatNumber(quantity.doubleValueForUnit(self.heartRateUnit)))
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  private func addActiveEnergySamples(samples: [HKSample]?)
  {
    guard let samples = samples as? [HKQuantitySample] else { return }
    
    self.totalActiveEnergyBurned = samples.reduce(self.totalActiveEnergyBurned) {
      $0 + $1.quantity.doubleValueForUnit(HKUnit.kilocalorieUnit())
    }
    
    self.activeEnergySamples.append(samples.last!)
    self.calVal.setText(formatNumber(self.totalActiveEnergyBurned))
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func formatNumber(value: Double) -> String
  {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    formatter.maximumFractionDigits = 0
    let numberString = formatter.stringFromNumber(value)
    return numberString!
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func startWorkout()
  {
    self.healthStore.startWorkoutSession(self.workoutSession!)
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func stopWorkoutAndSave()
  {
    self.healthStore.endWorkoutSession(self.workoutSession!)
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func saveWorkout()
  {
    guard let startDate = self.workoutStartDate, endDate = self.workoutEndDate else { return }
    
    let workout = HKWorkout(activityType: self.workoutSession!.activityType,
      startDate: startDate,
      endDate: endDate, duration: endDate.timeIntervalSinceDate(startDate),
      totalEnergyBurned: HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: self.totalActiveEnergyBurned),
      totalDistance: nil,
      device: nil,
      metadata: nil)
    
    var allSamples: [HKQuantitySample] = []
    allSamples += self.activeEnergySamples
    allSamples += self.heartRateSamples
    
    self.healthStore.saveObject(workout) { (success, error) -> Void in
      if success && allSamples.count > 0 {
        self.healthStore.addSamples(allSamples, toWorkout: workout, completion: { (success, error) -> Void in })
      }
    }
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func workoutDidStart(date: NSDate)
  {
    self.workoutStartDate = date
    queries.append(self.createStreamingActiveEnergyQuery(date))
    queries.append(self.createStreamingHeartRateQuery(date))
    
    for query in queries {
      self.healthStore.executeQuery(query)
    }
    self.delegate?.workoutSessionManager(self, didStartWorkoutWithDate: date)
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func workoutDidEnd(date: NSDate)
  {
    self.workoutEndDate = date
    
    for query in queries {
      self.healthStore.stopQuery(query)
    }
    
    self.queries.removeAll()
    self.delegate?.workoutSessionManager(self, didStopWorkoutWithDate: date)
    self.saveWorkout()
  }
  
  
  
  /**********************************************************************
   *
   **********************************************************************/
  func animateHeart(heartRate: Double)
  {
    self.animateWithDuration(0.3) {
      self.heart.setWidth(25)
      self.heart.setHeight(20)
    }
    
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1*double_t(NSEC_PER_SEC)))
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_after(when, queue) {
      dispatch_async(dispatch_get_main_queue(), {
        self.animateWithDuration(0.2, animations: {
          self.heart.setWidth(20)
          self.heart.setHeight(15)
        })
      })
    }
  }
}

/**********************************************************************
 *	MARK: HealthKit
 **********************************************************************/
extension WorkoutController
{
  /**********************************************************************
   *
   **********************************************************************/
  func createStreamingHeartRateQuery(date: NSDate) -> HKQuery {
    let predicate = HKQuery.predicateForSamplesWithStartDate(date, endDate: nil, options: .None)
    
    let query = HKAnchoredObjectQuery(type: self.heartRateType!, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
    }
    query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
      self.addHeartRateSamples(samples)
      let rate = (samples as! [HKQuantitySample]?)?.last?.quantity.doubleValueForUnit(self.heartRateUnit)
      self.animateHeart(rate!)
    }
    
    return query
  }
  
  
  
  /**********************************************************************
   *
   **********************************************************************/
  func createStreamingActiveEnergyQuery(workoutStateDate: NSDate) -> HKQuery
  {
    let predicate = self.predicateForSamplesToday()
    
    let query = HKAnchoredObjectQuery(type: self.activeEnergyType!, predicate: predicate, anchor: anchor, limit: 0) { (query, samples, deletedObjects, newAnchor, error) -> Void in
      guard let newAnchor = newAnchor else {return}
      self.anchor = newAnchor
    }
    query.updateHandler = { (query, samples, deletedObjects, newAnchor, error) -> Void in
      guard let newAnchor = newAnchor else {return}
      self.anchor = newAnchor
      self.addActiveEnergySamples(samples)
    }
    self.delegate?.workoutSessionManager(self, didUpdateActiveEnergyQuantity: self.currentActiveEnergyQuantity!)
    
    return query
  }
  
  
  /**********************************************************************
   *
   **********************************************************************/
  func authorizeHealthKit()
  {
    let typesToRead = Set([
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalEnergyBurned)!,
      ])
    let typesToShare = Set([HKQuantityType.workoutType()])
    self.healthStore.requestAuthorizationToShareTypes(typesToShare, readTypes: typesToRead) { (success, error) -> Void in }
  }
  
  /**********************************************************************
   *
   **********************************************************************/
  func predicateForSamplesToday() -> NSPredicate
  {
    let calendar = NSCalendar.currentCalendar()
    let endDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: workoutStartDate!, options: [.WrapComponents])
    return HKQuery.predicateForSamplesWithStartDate(workoutStartDate, endDate: endDate, options: HKQueryOptions.StrictStartDate)
  }
}
