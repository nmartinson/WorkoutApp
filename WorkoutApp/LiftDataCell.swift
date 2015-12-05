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
  @IBOutlet weak var setLabel: UILabel!
  @IBOutlet weak var prImage: UIImageView!
  @IBOutlet weak var currentPR: UILabel!
  
  var indexPath:NSIndexPath?
  var delegate:LiftDataCellDelegate?
  
  @IBAction func editPressed(sender: AnyObject) {
  	delegate?.editLiftPressed(indexPath!)
  }
  
  @IBAction func addSetPressed(sender: UIButton)
  {
    delegate?.addSetPressed(indexPath!)
  }
}