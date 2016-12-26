//
//  CommandCenter.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

enum CommandCenterError: Error {
    case WeatherServicesUnavailable
}


/**
 Abstraction to interact with system services
 */
class CommandCenter {
    //  Facade design pattern to encapsulate the various weather, location, and store services
    
    static      let shared      = CommandCenter()
    fileprivate var localStore  = LocalStore()
    
    fileprivate var weatherServices: [WeatherServiceDataSource]
    
    init() {
        weatherServices = [
            OpenWeatherMapService(),
            
            // The idea is to have multiple weather data sources to pull data from.
            // This is so we can use caching, redundancey, and access to information that
            // only certain services may provide.  For example, OpenWeatherMap doesn't provide
            // an hourly forecast, but we could talk to another source that does.
            //self.localStore,
        ]

    }
}


// MARK: WeatherDataSource
extension CommandCenter: WeatherServiceDataSource {

    internal func currentForecast(atLocation location: Location, completion: @escaping (Forecast?, WeatherServiceError?) -> Void) {
        if let service = weatherServices.first {
            service.currentForecast(atLocation: location, completion: { (forecast:Forecast?, error:WeatherServiceError?) in

                completion(forecast, error)
            })
        }
    }
    
    internal func dailyForecast(atLocation location: Location, numberOfDays: Int, completion: @escaping (DailyForecast?, WeatherServiceError?) -> Void) {
        if let service = weatherServices.first {
            service.dailyForecast(atLocation: location, numberOfDays: numberOfDays, completion: { (forecast:DailyForecast?, error:WeatherServiceError?) in
                
                completion(forecast, error)
            })
        }
        
    }
}
