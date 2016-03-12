//
//  ViewController.swift
//  iTips
//
//  Created by Tope Daramola on 12/14/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, SettingsViewControllerDelegate {
    
    
    //Basic Version Outlets
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipSelectorControl: UISegmentedControl!
    var tipPercentages = [Double]() //made this global to increase the scope to other functions
    
    //Custom Version Outlets
    @IBOutlet weak var tipTotalForTwo: UILabel!
    @IBOutlet weak var tipTotalForThree: UILabel!
    @IBOutlet weak var tipTotalForFour: UILabel!
    @IBOutlet weak var tipTotalForFive: UILabel!
    let gradientLayer = CAGradientLayer()
    let BLUR_VIEW_TAG = 99
    
    //Outlets for animations
    @IBOutlet weak var tipTotalForTwo_rightMargin: NSLayoutConstraint!
    @IBOutlet weak var tipTipLabelForTwo_leftMargin: NSLayoutConstraint!
    @IBOutlet weak var tipTotalForThree_rightMargin: NSLayoutConstraint!
    @IBOutlet weak var tipTipLabelForThree_leftMargin: NSLayoutConstraint!
    @IBOutlet weak var tipTotalForFour_rightMargin: NSLayoutConstraint!
    @IBOutlet weak var tipTipLabelForFour_leftMargin: NSLayoutConstraint!
    @IBOutlet weak var tipTotalForFive_rightMargin: NSLayoutConstraint!
    @IBOutlet weak var tipTipLabelForFive_leftMargin: NSLayoutConstraint!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the navigation bar
        self.navigationController?.navigationBarHidden = true
        
        //Make sure tipSelectorControl and tipPercentages have the correct value if they exist in NSUserDefaults
        updatePercentageValues()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Perform fancy intro animation
        performLaunchAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set inital tip and total bill values
        tipLabel.text = "$0.00"
        totalBillLabel.text = "$0.00"
        
        //Set initial tip percentage
        let defaults = NSUserDefaults.standardUserDefaults()
        let intValue = defaults.integerForKey("defaultTipValue")
        tipSelectorControl.selectedSegmentIndex = intValue
        
        //Set text field as first responder so that decimal pad automatically shows
        billTextField.becomeFirstResponder()
        
        //customize the background
        customizeView()
        
    }
    
    /**
     This function manipulates the constraints on the "Split Bill" UI elements
     */
    func performLaunchAnimation(){
        
        //initally set constant to value that pushed view out of sight
        self.tipTotalForTwo_rightMargin.constant = -108
        self.tipTipLabelForTwo_leftMargin.constant = -108
        self.tipTotalForThree_rightMargin.constant = -108
        self.tipTipLabelForThree_leftMargin.constant = -108
        self.tipTotalForFour_rightMargin.constant = -108
        self.tipTipLabelForFour_leftMargin.constant = -108
        self.tipTotalForFive_rightMargin.constant = -108
        self.tipTipLabelForFive_leftMargin.constant = -108
        self.view.layoutIfNeeded()
        
        //animate the views back in sight by setting correct values for constraints
        UIView.animateWithDuration(0.45, animations: {
            
            self.tipTotalForTwo_rightMargin.constant = 15
            self.tipTipLabelForTwo_leftMargin.constant = 15
            
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(0.65, animations: {
            
            self.tipTotalForThree_rightMargin.constant = 15
            self.tipTipLabelForThree_leftMargin.constant = 15
            
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(0.85, animations: {
            
            self.tipTotalForFour_rightMargin.constant = 15
            self.tipTipLabelForFour_leftMargin.constant = 15
            
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(1.05, animations: {
            
            self.tipTotalForFive_rightMargin.constant = 15
            self.tipTipLabelForFive_leftMargin.constant = 15
            
            self.view.layoutIfNeeded()
        })
        
        
        
    }
    
    /**
     Customize the view with a gradient background
     */
    func customizeView() {
        
        let colorTop = UIColor(red: 43.0/255.0, green: 210.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor
        //let colorBottom = UIColor(red: 215.0/255.0, green: 210.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 148.0/255.0, green: 142.0/255.0, blue: 153.0/255.0, alpha: 1.0).CGColor
        
        
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        
        view.backgroundColor = UIColor.clearColor()
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, atIndex: 0) //Insert the gradient layer behind all other views
    }
    
    
    /**
     Updates the UI whenever the user inputs a new Bill amount or whenever a different tip percentage is selected
     */
    @IBAction func onEditingChanged(sender: AnyObject) {
        
        //Get selected tip percentage
        let tipPercentage = tipPercentages[tipSelectorControl.selectedSegmentIndex]
        
        //Get the bill about input by the user (Note: if the user does not enter any thing, the ".doubleValue" property evaluates to 0)
        let billAmount = NSString(string: billTextField.text!).doubleValue
        
        //Calculate tip amount
        let tipAmount = billAmount * tipPercentage
        
        //Calculate total bill amount
        let totalBillAmount = billAmount + tipAmount
        
        //Update UI
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalBillLabel.text = String(format: "$%.2f", totalBillAmount)
        
        tipTotalForTwo.text = String(format: "$%.2f", totalBillAmount/2)
        tipTotalForThree.text = String(format: "$%.2f", totalBillAmount/3)
        tipTotalForFour.text = String(format: "$%.2f", totalBillAmount/4)
        tipTotalForFive.text = String(format: "$%.2f", totalBillAmount/5)
        
    }
    
    /**
     Dismiss keyboard on tap of self.view
     
     - parameter sender: anyObject
     */
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    /**
     Sets a blur overlay on top of the view stack. A tag is given to this view so that is can be refrenced and removed later on
     
     - parameter sender: AnyObject
     */
    @IBAction func blurView(sender: AnyObject) {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.tag = BLUR_VIEW_TAG
        blurView.frame = view.bounds
        view.addSubview(blurView)
    }
    
    /**
     Update the gradient layer from when the orientation of the device changes
     */
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = view.bounds;
    }
    
    /**
     Segue is needed to set the self as the delegate for the SettingsViewController
     
     - parameter segue:  UIStoryboardSegue
     - parameter sender: AnyObject?
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showSettings") {
            let targetViewControler = segue.destinationViewController as! SettingsViewController
            
            targetViewControler.delegate = self
        }
        
    }
    
    /**
     Delegate method that is called whenever a new percentage is selected in the SettingsViewController and the view is dismissed
     */
    func updateUIWithNewSettings() {
        
        //remove the blur subview
        view.viewWithTag(BLUR_VIEW_TAG)?.removeFromSuperview()
        
        
        //update the default percentage
        let defaults = NSUserDefaults.standardUserDefaults()
        let intValue = defaults.integerForKey("defaultTipValue")
        tipSelectorControl.selectedSegmentIndex = intValue
        
        //update the default percentage values
        updatePercentageValues()
        
        //Recalulate tip and totals using updated values
        onEditingChanged(self)
    }
    
    
    /**
     Updates tipSelectorControl and tipPercentages have the correct value if they exist in NSUserDefaults and are not equal to 0
     */
    func updatePercentageValues() {
        
        //get values from NSUserefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        let percentage1 = defaults.integerForKey("customPercentage1")
        let percentage2 = defaults.integerForKey("customPercentage2")
        let percentage3 = defaults.integerForKey("customPercentage3")
        
        if percentage1 != 0 && percentage2 != 0 && percentage3 != 0 {
            
            tipSelectorControl.setTitle(String(percentage1) + "%", forSegmentAtIndex: 0)
            tipSelectorControl.setTitle(String(percentage2) + "%", forSegmentAtIndex: 1)
            tipSelectorControl.setTitle(String(percentage3) + "%", forSegmentAtIndex: 2)
            
            tipPercentages = [Double(percentage1)/100, Double(percentage2)/100, Double(percentage3)/100]
            
            
        }
        else {
            //Use these default  values
            tipPercentages = [0.18, 0.2, 0.22]
        }
        
    }
    
    /**
     UITextField delegate method checks the amout of decimals (.) the user has input and returns false
     Also checks if the user inputs a value greater that 6 digits (excluding the decimal point)
     
     - parameter textField: the active textField (billTextField)
     - parameter range:     range of chatacters in string
     - parameter string:    the input string input to the textfield
     
     - returns: YES/true if the specified text range should be replaced; otherwise, NO/false to keep the old text.
     */
    func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let countdots = textField.text!.componentsSeparatedByString(".").count - 1
        
        if countdots > 0 && string == "." {
            return false
        }
        else if (textField.text?.characters.count >= (6 + countdots) && string != "") {
            return false
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

