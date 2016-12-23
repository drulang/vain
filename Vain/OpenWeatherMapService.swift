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
        
        let forecast = MultiDayForecast()
        let f1 = Forecast()
        let f2 = Forecast()
        let f3 = Forecast()
        let f4 = Forecast()
        let f5 = Forecast()
        forecast.days = [f1, f2, f3, f4, f5]
        
        completion(forecast, nil)
    }
    
    internal func currentForecast(atLocation location: Location, completion: (Forecast?, WeatherServiceError?) -> Void) {
        let forecast = Forecast()

        forecast.date = Date()
        forecast.current = NSMeasurement(doubleValue: 75, unit: UnitTemperature.fahrenheit)
        forecast.hi = NSMeasurement(doubleValue: 74, unit: UnitTemperature.fahrenheit)
        forecast.lo = NSMeasurement(doubleValue: 60, unit: UnitTemperature.fahrenheit)
        
        completion(forecast, nil)
    }
    
}
