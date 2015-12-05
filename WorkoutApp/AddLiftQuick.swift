//
//  AddLiftQuick.swift
//
//
//  Created by Nick on 11/29/15.
//
//

import UIKit
import TextFieldEffects
import CoreData

protocol AddLiftQuickDelegate
{
  func addedSet()
  func didDismissPopover()
}

/**************************************************************************
 *
 ***************************************************************************/
class AddLiftQuick: UIViewController
{
  @IBOutlet weak var weightField: YoshikoTextField!
  @IBOutlet weak var repsField: YoshikoTextField!
  @IBOutlet weak var liftName: UILabel!
  let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
  var session:SessionEntity?
  var delegate:AddLiftQuickDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setSessionObject(session: SessionEntity) {
    self.session = session
  }
  

  
  @IBAction func savePressed(sender: UIButton) {
    
    let weight = Double(weightField.text!)
    let repCount = Int(repsField.text!)
    CDSetHelper().addSet(session!, weight: weight!, repCount: repCount!, movement: liftName.text!)
    delegate?.addedSet()
    dismissViewControllerAnimated(true, completion: nil)

  }
  
  @IBAction func cancelPressed(sender: UIButton) {
		delegate?.didDismissPopover()
  	dismissViewControllerAnimated(true, completion: nil)
  }
}

/**************************************************************************
 *
 ***************************************************************************/
extension AddLiftQuick: UITextFieldDelegate
{
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == repsField {
      weightField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
}
