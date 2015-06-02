//
//  LNCreateLocationViewController.swift
//  LocalNotificationsExample
//
//  Created by KimYoonBong on 2015. 6. 1..
//  Copyright (c) 2015년 KimYoonBong. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class LNCreateLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate {

    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!
    
    var isFistUpdated: Bool = false
    var locationManager = CLLocationManager()
    var annotation = MKPointAnnotation()
    
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        longPressGestureRecognizer.addTarget(self, action: "movePin:")
    }
    
    override func viewWillAppear(animated: Bool) {
        removeLocationNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeLocationNotification()   {
        
        for notification: AnyObject in UIApplication.sharedApplication().scheduledLocalNotifications     {
            
            if let noti = notification as? UILocalNotification  {
                if noti.fireDate == nil {
                    UIApplication.sharedApplication().cancelLocalNotification(noti)
                }
            }
        }
    }
    
    @IBAction func doAddLocationNotification(sender: UIBarButtonItem) {
        
        var newNotifications = UILocalNotification()
        newNotifications.alertBody = "You are nearby \(annotation.title)"
        newNotifications.regionTriggersOnce = true
        newNotifications.region = CLCircularRegion(center: annotation.coordinate, radius: 100, identifier: "Destination!!")
        newNotifications.userInfo = ["location": [annotation.coordinate.latitude, annotation.coordinate.longitude]]
        
        UIApplication.sharedApplication().scheduleLocalNotification(newNotifications)
        
    }

    // MARK: - MKMapView delegate

    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {

        if self.isFistUpdated    {
            return
        }
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(userLocation.coordinate, span)

        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        self.isFistUpdated = true
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotation")
        pin.animatesDrop = true
        pin.canShowCallout = true
        
        return pin
    }

    
    // MARK: - CLLocationManager delegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        println("status: \(status.rawValue)")
        
        if status == .Denied || status == .NotDetermined {
            
            let alertView = UIAlertView(title: "IMPORTANT!", message: "If you want to use location-based notification, you have to turn on 'Always' in the Location Service Settings", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Go Settings")
            
            alertView.show()
        }
    }
    
    
    // MARK: - UIAlertView delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.cancelButtonIndex == buttonIndex   {
            return
        }
        
        let settingURL = NSURL(string: UIApplicationOpenSettingsURLString)
        
        if let validURL = settingURL    {
            UIApplication.sharedApplication().openURL(validURL)
        }
        
    }
    
    
    // MARK: - GestureRecognizer selector
    func movePin(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .Ended  {
            
            if self.mapView.annotations.count > 1 {
                self.mapView.removeAnnotation(annotation)
            }
            
            let point = gesture.locationInView(self.mapView)
            let newCoordinate = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
            
            annotation.coordinate = newCoordinate
            self.mapView.addAnnotation(annotation)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (address, error) -> Void in
                let lastObject = address.last as! CLPlacemark
                var string = ABCreateStringWithAddressDictionary(lastObject.addressDictionary, false) as String

                self.annotation.title = string.stringByReplacingOccurrencesOfString("\n", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                self.mapView.selectAnnotation(self.annotation, animated: true)
            })
        }
    }
}
