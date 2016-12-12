//
//  OpenWeatherMapService.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

class OpenWeatherMapService {
    
}


//MARK: WeatherDataSource
extension OpenWeatherMapService: WeatherServiceDataSource {
    
    internal func fiveDayForecast(atLocation location: Location, completion: (MultiDayForecast?, WeatherServiceError?) -> Void) {

    }
    
    internal func currentForecast(atLocation location: Location, completion: (Forecast?, WeatherServiceError?) -> Void) {
        let forecast = Forecast()
        forecast.date = Date()
  
        completion(forecast, nil)
    }
    
}
