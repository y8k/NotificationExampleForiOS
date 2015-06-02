//
//  AppDelegate.swift
//  LocalNotificationsExample
//
//  Created by KimYoonBong on 2015. 5. 29..
//  Copyright (c) 2015년 KimYoonBong. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // For Parse
        Parse.setApplicationId("Ob0oAUGLasjHk0mGd4KMQPpGHFwLajvXARtYetSF", clientKey: "VTpcD7Gs8BqzE9V2CVMnWaDZCMwabomqgOp3a9eA")
        
        // For iOS8
        if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)) {
            
            let types = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            
            
            // MARK: - Actions and Category for Local Notification
            let localAction1 = UIMutableUserNotificationAction()
            localAction1.activationMode = UIUserNotificationActivationMode.Foreground
            localAction1.title = "Action1"
            localAction1.identifier = "ACTION1"
            localAction1.destructive = false
            localAction1.authenticationRequired = false
            
            let localAction2 = UIMutableUserNotificationAction()
            localAction2.activationMode = .Background
            localAction2.title = "Action2"
            localAction2.identifier = "ACTION2"
            localAction2.destructive = false
            localAction2.authenticationRequired = false
            
            let localCategory = UIMutableUserNotificationCategory()
            localCategory.identifier = "CATEGORY1"
            localCategory.setActions([localAction1, localAction2], forContext: UIUserNotificationActionContext.Default)
            
            
            // MARK: - Actions and Category for Remote Notification
            let remoteAction1 = UIMutableUserNotificationAction()
            remoteAction1.activationMode = UIUserNotificationActivationMode.Foreground
            remoteAction1.title = "Action3"
            remoteAction1.identifier = "ACTION3"
            remoteAction1.destructive = false
            remoteAction1.authenticationRequired = false
            
            let remoteAction2 = UIMutableUserNotificationAction()
            remoteAction2.activationMode = .Background
            remoteAction2.title = "Action4"
            remoteAction2.identifier = "ACTION4"
            remoteAction2.destructive = false
            remoteAction2.authenticationRequired = false
            
            let remoteCategory = UIMutableUserNotificationCategory()
            remoteCategory.identifier = "CATEGORY2"
            remoteCategory.setActions([remoteAction1, remoteAction2], forContext: UIUserNotificationActionContext.Default)
            
            
            var categorySet = Set<UIMutableUserNotificationCategory>()
            categorySet.insert(localCategory)
            categorySet.insert(remoteCategory)
            
            let settings = UIUserNotificationSettings(forTypes: types, categories: categorySet)
            application.registerUserNotificationSettings(settings)
        }
        

        if let options = launchOptions  {
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification  {
                
                if let body = notification.alertBody {
                    showAlert(application.applicationState, message:body)
                }
            }
        }
        
        application.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        if notification.category == "CATEGORY1" {
            
            if let id = identifier  {
                
                switch id   {
                case "ACTION1":
                    
                    let alertView = UIAlertView(title: "LOCAL NOTIFICATION", message: "You chose ACTION1! Right?!", delegate: nil, cancelButtonTitle: "Right!")
                    
                    alertView.show()
                    
                    break
                case "ACTION2":
                    NSNotificationCenter.defaultCenter().postNotificationName("LNSilentRemoteNotification", object: nil)
                    
                    break
                default:
                    break
                }
            }
        }
        
        completionHandler()
    }
    
    /*
    { "alert" : "HELLO?!", "category" : "CATEGORY2", }
    */

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>   {
            if let category = info["category"] as? String {
                
                if category == "CATEGORY2"  {
                    
                    if let id = identifier  {
                        
                        switch id   {
                        case "ACTION3":
                            
                            let alertView = UIAlertView(title: "REMOTE NOTIFICATION", message: "You chose ACTION3! Right?!", delegate: nil, cancelButtonTitle: "Right!")
                            
                            alertView.show()
                            
                            break
                        case "ACTION4":
                            NSNotificationCenter.defaultCenter().postNotificationName("LNSilentRemoteNotification", object: nil)
                            
                            break
                        default:
                            break
                        }
                    }
                    
                }
            }
        }

        
        
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        println("\(notification)")
        notification.applicationIconBadgeNumber = 0
        
        if let body = notification.alertBody {
            showAlert(application.applicationState, message: body)
        }
    }
    
    func showAlert(state: UIApplicationState, message: String) {
        
        var text: String = ""
        switch state    {
        case .Active:
            text = "Active "
            break
        case .Inactive:
            text = "Inactive "
            break
        case .Background:
            text = "Background "
            break
        default:
            text = "FirstRun "
            break
        }
        
        text += "Notification"
        
        let alertView = UIAlertView(title: text, message: message, delegate: nil, cancelButtonTitle: "Okay")
        
        alertView.show()
        
        NSNotificationCenter.defaultCenter().postNotificationName("LNReloadNotification", object: nil)
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        println("device token : \(deviceToken)")
        
        let parsePushInstallation = PFInstallation.currentInstallation()
        parsePushInstallation.setDeviceTokenFromData(deviceToken)
        parsePushInstallation.channels = ["global"]
        
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        println("error :\(error.localizedDescription)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        println("\(userInfo)")
        
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>   {
            if let silent = info["content-available"] as? Bool {
                println("\(silent)")
                NSNotificationCenter.defaultCenter().postNotificationName("LNSilentRemoteNotification", object: nil)
                
                completionHandler(UIBackgroundFetchResult.NewData)
            }
            else    {
                
                PFPush.handlePush(userInfo)
                
                completionHandler(UIBackgroundFetchResult.NoData)
            }
        }
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

