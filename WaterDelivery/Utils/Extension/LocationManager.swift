//
//  LocationManager.swift
//  Business App
//
//  Created by Ratna Sagar on 16/10/19.
//  Copyright © 2019 Ratna Sagar. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

 enum LocationManageState {
 case failed
 case updating
 case stoped
 case paused
 }

class LocationManager: NSObject {
    
    /// Core location
    private let locationManager: CLLocationManager =  CLLocationManager()
    
    /// Location manager current state
      var state = LocationManageState.stoped
    
    /// Location
    var currentLocation = CLLocation()
    var currentAddress = ""
    var country = ""
    var postalCode = ""
    var street = ""
    var city = ""
    var district = ""
    var stateName = ""
    
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    ///Start Location updation
    func requestLocationAtOnce() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //iOS 9 and later
        //    state = .updating
          if getPermission() == false {
            displayAlertWithTitleMessageAndTwoButtons()
         }
    }
    
    /// Get Permission from User
    func getPermission() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .denied, .restricted, .notDetermined:
            return false
            /*    case .restricted:
             return false
             case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
             return getPermission()
             */
        @unknown default:
            fatalError()
        }
        //  return false
    }
    
    
     ///Stop Location Updation
     func stopUpdating() {
       locationManager.stopUpdatingLocation()
       state = .stoped
     }
    

    
    /// Display Permission alert
    func displayAlertWithTitleMessageAndTwoButtons() {
        let alertController = UIAlertController(title: "Enable Location",
                                                message: "The location permission was not authorized. Please enable it in Settings to continue.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            /// Settings url
            //  let locationUrl = URL(string: "App-Prefs:root=Privacy&path=Bluetooth")
            UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)! as URL, options: [:], completionHandler: nil)
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      //  appDelegate.window?.rootViewController!.presentedViewController?.present(alertController, animated: true, completion: nil)
    }
}

/// Location manager delegate methods
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Did Location access permission was changed: \(status)")
        switch status {
        case .denied:
            print("get Location permission to access")
            self.displayAlertWithTitleMessageAndTwoButtons()
        case .notDetermined,.restricted:
            print("get Location permission to access")
            manager.requestWhenInUseAuthorization()
        default:
            print("Permission given")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        state = .updating
        manager.stopUpdatingLocation()
        if ((locations.first?.coordinate) != nil) {
            if let location = locations.first{
                currentLocation = location
            }

        }
        print("Location updated: \(String(describing: locations.first?.coordinate))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // state = .failed
        print("Failed to update Locations: \(error.localizedDescription)")
        manager.requestLocation() //iOS 9 and later
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
          state = .paused
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
         state = .updating
    }
}
