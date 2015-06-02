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
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        

        if let options = launchOptions  {
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification  {
                
                notification.applicationIconBadgeNumber = 0
                
                if let body = notification.alertBody {
                    showAlert(application.applicationState, message: body)
                }
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
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
        
        NSNotificationCenter.defaultCenter().postNotificationName("LNSilentRemoteNotification", object: nil)
        
        completionHandler(UIBackgroundFetchResult.NewData)
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

