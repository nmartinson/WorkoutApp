//
//  IntervalTimerViewController.swift
//
//
//  Created by Nick on 12/15/15.
//
//

import UIKit

class IntervalTimerViewController: UIViewController {
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var restLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func resetTimer() {
    timerLabel.text = "0.0"
  }
  
  
}
