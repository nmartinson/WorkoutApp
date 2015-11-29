//
//  LiftDetailController.swift
//  WorkoutApp
//
//  Created by Nick on 10/28/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

class LiftDetailController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var liftName: UILabel!
    @IBOutlet weak var setNumber: UILabel!
    @IBOutlet weak var repNumber: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var navigationBarView: UIView!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedSet:SetEntity?
    
    override func viewDidLoad()
    {
		navigationBarView.backgroundColor = BAR_TINT_COLOR
        self.view.backgroundColor = PRIMARY_COLOR
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:BACK_IMG, style:.Plain, target:self, action:"backButtonPressed:")

        //        setNumber.text = selectedSet
        liftName.text = selectedSet!.movementType!
        repNumber.text = String(selectedSet!.repCount!)
        weightTextField.placeholder = String(selectedSet!.weight!)
    }
    override func viewDidAppear(animated: Bool) {

    }
    
    @IBAction func swipedRight(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
	}
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePressed(sender: AnyObject)
    {
        print("Weight: \(weightTextField.text!)")
        selectedSet?.weight = Float(weightTextField.text!)
        CDSetHelper().updateSet(selectedSet!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}