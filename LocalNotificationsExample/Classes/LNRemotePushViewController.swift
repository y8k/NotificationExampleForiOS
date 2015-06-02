//
//  LNRemotePushViewController.swift
//  LocalNotificationsExample
//
//  Created by KimYoonBong on 2015. 6. 2..
//  Copyright (c) 2015년 KimYoonBong. All rights reserved.
//

import UIKit

class LNRemotePushViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        label.text = "NORMAL"
        label.textColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotReceivedSilentPush", name: "LNSilentRemoteNotification", object: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "LNSilentRemoteNotification", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func gotReceivedSilentPush()    {
        
        label.text = "SILENT"
        label.textColor = UIColor.redColor()
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
