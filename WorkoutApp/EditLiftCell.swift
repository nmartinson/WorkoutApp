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
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
