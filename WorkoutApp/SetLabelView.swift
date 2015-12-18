//
//  SetLabelView.swift
//  
//
//  Created by Nick on 12/9/15.
//
//

import UIKit

class SetLabelView: UIStackView {

  @IBOutlet weak var setLabel: UILabel!
  @IBOutlet weak var seperatorImage: UIImageView!
  @IBOutlet weak var restTimeLabel: UILabel!
  @IBOutlet weak var restStack: UIStackView!


  class func instanceFromNib() -> UIView {
    return UINib(nibName: "SetLabelView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIStackView
  }

  class func loadNib() -> UIView {
   let setView = NSBundle.mainBundle().loadNibNamed("SetLabelView", owner: nil, options: nil)[0] as? UIStackView
		return setView!
  }
  
  
}