//
//  LocationService.swift
//  Pods-Sauron_Example
//
//  Created by Horacio Guzman on 11/16/18.
//

import Foundation
import CoreLocation

internal class LocationService: NSObject{
    static let shared = LocationService()
    private override init(){
        super.init()
    }
    private(set) var lastLocation: CLLocation?
    private var locationManager = CLLocationManager()
    
    var errorHandler: ((Error?) -> Void)?
    
    func configureLocationService(){
        ////print("ConfigureLocationService")
        if CLLocationManager.locationServicesEnabled() == true{
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
                locationManager.requestAlwaysAuthorization()
            }
            if CLLocationManager.authorizationStatus() == .authorizedAlways{
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.startUpdatingLocation()
            }else{
                //print("Otro permiso \(CLLocationManager.authorizationStatus())")
            }
        }else{
            //print("No estan activos los servicios de localización")
        }
    }
}

extension LocationService: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastLocation = locations.last
        ////print("Update Locations at \(self.lastLocation?.timestamp.HourAsString(includeSeconds: true) ?? "default")")
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self.lastLocation!) { (marks, error) in
            if let placemark = marks?.last{
                ////print("Update Locations at \(self.lastLocation?.timestamp.HourAsString(includeSeconds: true) ?? "default") in \(placemark.country!)")
                UserDefaults.standard.set(placemark.country, forKey: "country")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
        }
    }
}
