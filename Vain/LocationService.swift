//
//  LocationService.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

class LocationService {
}


//MARK: CurrentLocationDataSource
extension LocationService: CurrentLocationDataSource {

    internal func currentLocation(completion: (Location?, LocationServiceError?) -> Void) {
        //TODO: Use CoreLocation framework
        let location = Location()
        location.name = "London"
        location.displayName = "London"
        location.modelId = 2643743
        
        completion(location, nil)
    }

}
