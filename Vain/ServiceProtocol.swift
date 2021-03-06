//
//  ServiceProtocol.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

enum WeatherServiceError : Error {
    case UnavailableError
    case DataSerializationError
    case ParameterError
}

enum LocationServiceError: Error {
    case UnavailableError
    case AuthorizationError
    case ReverseGeocodeError
    case UnauthorizedError
}



/**
 Provides weather information such as current weather, 5 day forecast, etc.
 */
protocol WeatherServiceDataSource {
    
    func currentForecast(atLocation location:Location, completion:@escaping (_:Forecast?, _:WeatherServiceError?)->Void);
    func dailyForecast(atLocation location:Location, numberOfDays:Int, completion:@escaping (_:DailyForecast?, _:WeatherServiceError?)->Void);

}


/**
 Provides the user's current location
 */
protocol CurrentLocationDataSource {
    
    var userAuthorizedLocationUse: Bool { get }

    func requestLocationUseAuthorization(completion: @escaping (LocationServiceError?) -> Void)
    func currentLocation(completion:@escaping (_:Location?, _:LocationServiceError?)->Void);

}


/**
 Save users location to a store
 */
protocol LocationStore {
    
}
