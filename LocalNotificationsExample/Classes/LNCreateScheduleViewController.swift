//
//  LNCreateScheduleViewController.swift
//  LocalNotificationsExample
//
//  Created by KimYoonBong on 2015. 5. 30..
//  Copyright (c) 2015년 KimYoonBong. All rights reserved.
//

import UIKit

class LNCreateScheduleViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DONE"   {
            registerLocalNotification()
        }
    }
    
    func registerLocalNotification()    {
        
        let secondsString = secondsTextField.text as NSString
        let seconds = secondsString.doubleValue
        
        var newNotification = UILocalNotification()
        newNotification.fireDate = NSDate(timeIntervalSinceNow: seconds)
        newNotification.alertBody = titleTextField.text
        newNotification.soundName = UILocalNotificationDefaultSoundName
        newNotification.timeZone = NSTimeZone.defaultTimeZone()
        newNotification.applicationIconBadgeNumber = 1
        
        if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 2, patchVersion: 0)) {
          newNotification.alertTitle = "Local Notification Ex."
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(newNotification)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == "DONE" {
            
            if titleTextField.isFirstResponder()    {
                titleTextField.resignFirstResponder()
            }
            
            if secondsTextField.isFirstResponder()  {
                secondsTextField.resignFirstResponder()
            }

            if count(titleTextField.text) < 1   {
                titleTextField.placeholder = "You have to write one or more character(s)."
                titleTextField.becomeFirstResponder()
                
                return false
            }
            
            if count(secondsTextField.text) < 1    {
                secondsTextField.placeholder = "Enter what you want to get notification time"
                secondsTextField.becomeFirstResponder()
                
                return false
            }
        }
        
        return true
    }

    // MARK: - UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.isEqual(titleTextField)    {
            secondsTextField.becomeFirstResponder()
        }
        else    {
            secondsTextField.resignFirstResponder()
        }
        
        return false
    }

}
