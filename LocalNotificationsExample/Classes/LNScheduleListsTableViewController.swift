//
//  LNScheduleListsTableViewController.swift
//  LocalNotificationsExample
//
//  Created by KimYoonBong on 2015. 5. 30..
//  Copyright (c) 2015년 KimYoonBong. All rights reserved.
//

import UIKit

class LNScheduleListsTableViewController: UITableViewController {

    private(set) var notifications: [AnyObject] = []
    
    @IBOutlet weak var removeAllBarButtonItem: UIBarButtonItem!
    @IBOutlet var notificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        loadLocalNotificaionsLists()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: "LNReloadNotification", object: nil)
    }
    
    deinit  {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "LNReloadNotification", object: nil)
    }
    
    
    func loadLocalNotificaionsLists()   {
        
        let application = UIApplication.sharedApplication()
        
        if let registeredNotifications = application.scheduledLocalNotifications    {
            
            for notification in registeredNotifications {
                
                if notification.fireDate != nil   {
                    notifications.append(notification)
                }
                
            }
            
            removeAllBarButtonItem.enabled = notifications.count > 0 ? true : false
            notificationsTableView.reloadData()
        }
    }
    
    func stringFromDate(date: NSDate) -> String  {
        
        let dateFomatter = NSDateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        dateFomatter.timeZone = NSTimeZone.defaultTimeZone()
        
        return dateFomatter.stringFromDate(date)
    }
    
    
    // MARK: - UIBarButtonItem selector
    
    @IBAction func doRemoveAllNotifications(sender: UIBarButtonItem) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        notifications.removeAll(keepCapacity: false)
        removeAllBarButtonItem.enabled = false
        
        notificationsTableView.reloadData()
    }
    
    // MARK: - NSNotification selector
    
    func reload()   {
        loadLocalNotificaionsLists()
    }
    
    
    // MARK: - Unwind Segue
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
        if segue.identifier == "DONE"   {
            let alertView = UIAlertView(title: "", message: "Registered!", delegate: nil, cancelButtonTitle: "Okay")
            
            alertView.show()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LOCAL_NOTIFICATIONS_LIST_CELL", forIndexPath: indexPath) as! UITableViewCell

        if let notification = notifications[indexPath.row] as? UILocalNotification  {
            
            cell.textLabel!.text = notification.alertBody
            cell.detailTextLabel!.text = stringFromDate(notification.fireDate!)
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            if let notification = notifications[indexPath.row] as? UILocalNotification   {
             UIApplication.sharedApplication().cancelLocalNotification(notification)
                notifications.removeAtIndex(indexPath.row)
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
