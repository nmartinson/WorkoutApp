//
//  LiftDataCell.swift
//  WorkoutApp
//
//  Created by Nick on 11/29/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

protocol LiftDataCellDelegate
{
  func editLiftPressed(indexPath:NSIndexPath)
  func addSetPressed(indexPath:NSIndexPath)
}

class LiftDataCell: UITableViewCell
{
  @IBOutlet weak var insetView: UIView!
  @IBOutlet weak var liftName: UILabel!
  @IBOutlet weak var prImage: UIImageView!
  @IBOutlet weak var currentPR: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var newPRStack: UIStackView!
  @IBOutlet weak var setStack: UIStackView!
  
  var indexPath:NSIndexPath?
  var isExpanded = false
  var delegate:LiftDataCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let frame = editButton.imageView?.frame.origin

    editButton.imageView?.frame = CGRect(x: frame!.x, y: frame!.y, width: 10, height: 10)

  }

  func didSelect() {
    for set in setStack.subviews {
      if set != setStack.subviews.last {
        (set as! SetLabelView).restStack.hidden = isExpanded
      }
    }
    isExpanded = !isExpanded

  }
  
  func clearSetStack() {
    setStack.subviews.forEach({ $0.removeFromSuperview() })
  }
  
  func addSetToStack(set: Int, repCount: Int, weight: Double, rest:String?) {
    let setView = SetLabelView.loadNib() as! SetLabelView
    setView.setLabel.text = "Set \(set): \(repCount) x \(weight) lbs"
    setView.restTimeLabel.text = rest
    setStack.addArrangedSubview(setView)
  }
  
  @IBAction func editPressed(sender: AnyObject) {
  	delegate?.editLiftPressed(indexPath!)
  }
  
  @IBAction func addSetPressed(sender: UIButton)
  {
    delegate?.addSetPressed(indexPath!)
  }
}