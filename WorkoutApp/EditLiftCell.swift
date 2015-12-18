//
//  EditLiftCell.swift
//  WorkoutApp
//
//  Created by Nick on 12/3/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import TextFieldEffects

class EditLiftCell: UITableViewCell {
  @IBOutlet weak var repsField: YoshikoTextField!
  @IBOutlet weak var weightField: YoshikoTextField!
  @IBOutlet weak var setLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    repsField.delegate = self
    weightField.delegate = self
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}

extension EditLiftCell: UITextFieldDelegate
{
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}