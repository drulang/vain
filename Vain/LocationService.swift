//
//  LocationService.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation
import CoreLocation


private struct LocationServiceConfig {
    static let StopManagerAfterFailedAttempts = 15
}


class LocationService : NSObject {
    fileprivate let locationManager = CLLocationManager()
    fileprivate let geocode = CLGeocoder()
    fileprivate var currentLocationCompletionBlock : ((Location?, LocationServiceError?) -> Void)?
    fileprivate var requestAuthorizationCompletionBlock : ((LocationServiceError?) -> Void)?
    fileprivate var failedLocationManagerAttempts = 0
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }
}


//MARK: CurrentLocationDataSource
extension LocationService: CurrentLocationDataSource {

    internal var userAuthorizedLocationUse: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }

    internal func requestLocationUseAuthorization(completion: @escaping (LocationServiceError?) -> Void) {
        requestAuthorizationCompletionBlock = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    internal func currentLocation(completion: @escaping (Location?, LocationServiceError?) -> Void) {
        currentLocationCompletionBlock = completion

        if userAuthorizedLocationUse {
            locationManager.startUpdatingLocation()
        } else {
            completion(nil, LocationServiceError.AuthorizationError)
        }
    }

}


//MARK: Helpers
extension LocationService {

    fileprivate func reverseGeocode(location:CLLocation, completion:@escaping (_:Location?, _:Error?) -> Void) {
        log.debug("Attempting to reverse geocode: \(location)")
        geocode.reverseGeocodeLocation(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            var localLocation:Location?
            
            if error != nil {
                log.error("Error reverese geocoding: \(error)")
            }
            
            defer {
                completion(localLocation, error)
            }

            if let placemark = placemarks?.first {
                var name:String?
                
                if placemark.locality != nil {
                    name = placemark.locality
                } else if placemark.subLocality != nil{
                    name = placemark.subLocality
                } else if placemark.subAdministrativeArea != nil {
                    name = placemark.subAdministrativeArea
                } else if placemark.administrativeArea != nil {
                    name = placemark.administrativeArea
                } else if placemark.name != nil {
                    name = placemark.name
                }

                if name == nil {
                    log.warning("Unable to find a name for placemark: \(placemark)")
                }

                localLocation = Location(coordinate: location.coordinate, name: name)
            } else {
                log.warning("No placemark:CLPlacemark to extract information from")
            }
        }
    }
}


//MARK: LocationManager
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("Core Location Error: \(error)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        log.debug("Received Core Location Manager location update")

        guard let completion = currentLocationCompletionBlock else {
            log.warning("Attempting to fetch user's current location without a callback")
            manager.stopUpdatingLocation()
            return
        }

        guard let location = locations.last else {
            log.debug("Location Manager updated without a location")
            failedLocationManagerAttempts += 1
            return
        }
        
        defer {
            if failedLocationManagerAttempts >= LocationServiceConfig.StopManagerAfterFailedAttempts {
                log.warning("Reached max number of attempts.  Stopping Core Location Manager")
                locationManager.stopUpdatingLocation()
                failedLocationManagerAttempts = 0
            }
        }
        
        manager.stopUpdatingLocation()
        
        reverseGeocode(location: location) { (location:Location?, error:Error?) in
            let locationError = error != nil ? LocationServiceError.ReverseGeocodeError : nil
            completion(location, locationError)
            self.currentLocationCompletionBlock = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        log.debug("Core Location Auth Status changed: \(status)")

        guard status != .notDetermined else {
            log.debug("Core Location Auth Status changed, but has not been determined yet. Will not execute the requestAuthorizationCompletionBlock")
            return
        }

        if let completion = requestAuthorizationCompletionBlock {
            let error = status == CLAuthorizationStatus.authorizedWhenInUse ? nil : LocationServiceError.AuthorizationError
            completion(error)
        } else {
            log.debug("Authorization completion block is nil")
        }
    }
    
}
