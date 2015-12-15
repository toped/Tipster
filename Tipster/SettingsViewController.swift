//
//  SettingsViewController.swift
//  iTips
//
//  Created by Tope Daramola on 12/14/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func updateUIWithNewSettings()
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var toggleMoreOptionsBtn: UIButton!
    var delegate: SettingsViewControllerDelegate! = nil
    var additionalOptionsVisible = false
    
    //Outlets for Additional Options
    @IBOutlet weak var percentage1Field: UITextField!
    @IBOutlet weak var percentage2Field: UITextField!
    @IBOutlet weak var percentage3Field: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let intValue = defaults.integerForKey("defaultTipValue")
        defaultTipControl.selectedSegmentIndex = intValue
        
        
        updatePercentageValues()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(defaultTipControl.selectedSegmentIndex, forKey: "defaultTipValue")
        defaults.synchronize()
        
        delegate.updateUIWithNewSettings()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleMoreOptions(sender: AnyObject) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if (!additionalOptionsVisible) {
            
            //show additional options
            additionalOptionsVisible = true
            toggleMoreOptionsBtn.setTitle("v v v show less v v v", forState: UIControlState.Normal)
            
            //animate the more options into view
            UIView.animateWithDuration(0.55, animations: {
                
                self.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
                self.view.layoutIfNeeded()
            })
            
            
        }
        else {
            
            //hide additional options
            additionalOptionsVisible = false
            toggleMoreOptionsBtn.setTitle("^ ^ ^ show more ^ ^ ^", forState: UIControlState.Normal)
            
            let y = screenSize.height - 170
            
            UIView.animateWithDuration(0.55, animations: {
                
                self.view.frame = CGRectMake(0, y, screenSize.width, 170)
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if (!additionalOptionsVisible) {
            let y = screenSize.height - 170
            view.frame = CGRectMake(0, y, screenSize.width, 170)
        }
        else {
            self.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        }
    }
    
    @IBAction func updateDefaultPercentages(sender: UITextField) {
        
        let newPercentage = NSString(string: sender.text!).integerValue
        
        
        if sender == percentage1Field {
            defaultTipControl.setTitle(String(newPercentage) + "%", forSegmentAtIndex: 0)
            
            //save new percentage to NSUserDefaults
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(newPercentage, forKey: "customPercentage1")
            defaults.synchronize()
            
        }
        else if sender == percentage2Field {
            defaultTipControl.setTitle(String(newPercentage) + "%", forSegmentAtIndex: 1)
            
            //save new percentage to NSUserDefaults
            //save new percentage to NSUserDefaults
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(newPercentage, forKey: "customPercentage2")
            defaults.synchronize()
            
        }
        else {
            defaultTipControl.setTitle(String(newPercentage) + "%", forSegmentAtIndex: 2)
            
            //save new percentage to NSUserDefaults
            //save new percentage to NSUserDefaults
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(newPercentage, forKey: "customPercentage3")
            defaults.synchronize()
            
        }
        
        
    }
    
    func updatePercentageValues() {
        
        //get values from NSUserefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        let percentage1 = defaults.integerForKey("customPercentage1")
        let percentage2 = defaults.integerForKey("customPercentage2")
        let percentage3 = defaults.integerForKey("customPercentage3")
        
        if percentage1 != 0 && percentage2 != 0 && percentage3 != 0 {
            
            defaultTipControl.setTitle(String(percentage1) + "%", forSegmentAtIndex: 0)
            defaultTipControl.setTitle(String(percentage2) + "%", forSegmentAtIndex: 1)
            defaultTipControl.setTitle(String(percentage3) + "%", forSegmentAtIndex: 2)
            
        }
        
        
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        
        view.endEditing(true)
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
