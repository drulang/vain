//
//  MockWeatherService.swift
//  Vain
//
//  Created by Dru Lang on 1/4/17.
//  Copyright © 2017 Dru Lang. All rights reserved.
//

import Foundation

class DebugWeatherService {
    
}


//MARK: WeatherDataSource
extension DebugWeatherService: WeatherServiceDataSource {
    
    internal func dailyForecast(atLocation location: Location, numberOfDays: Int, completion: @escaping (DailyForecast?, WeatherServiceError?) -> Void) {
        
        let wc1 = WeatherCondition(condition: WeatherCondition.Condition.ClearSky, timeOfDay: WeatherCondition.TimeOfDay.Day)
        let f1 = Forecast(hi: 276.32, lo: 274.32, current: 275.32, condition: wc1, date: 1483563600.0)

        let wc2 = WeatherCondition(condition: WeatherCondition.Condition.Snow, timeOfDay: WeatherCondition.TimeOfDay.Day)
        let f2 = Forecast(hi: 276.32, lo: 274.32, current: 275.32, condition: wc2, date: 1483563600.0)
        
        let wc3 = WeatherCondition(condition: WeatherCondition.Condition.Rain, timeOfDay: WeatherCondition.TimeOfDay.Day)
        let f3 = Forecast(hi: 276.32, lo: 274.32, current: 275.32, condition: wc3, date: 1483563600.0)
        
        let wc4 = WeatherCondition(condition: WeatherCondition.Condition.Thunderstorm, timeOfDay: WeatherCondition.TimeOfDay.Day)
        let f4 = Forecast(hi: 276.32, lo: 274.32, current: 275.32, condition: wc4, date: 1483563600.0)
        
        let wc5 = WeatherCondition(condition: WeatherCondition.Condition.Clouds, timeOfDay: WeatherCondition.TimeOfDay.Day)
        let f5 = Forecast(hi: 276.32, lo: 274.32, current: 275.32, condition: wc5, date: 1483563600.0)
        
        let dailyForecast = DailyForecast()
        dailyForecast.days = [f1, f2, f3, f4, f5]
        
        completion(dailyForecast, nil)
    }
    
    
    internal func currentForecast(atLocation location: Location, completion: @escaping (Forecast?, WeatherServiceError?) -> Void) {
        let wc = WeatherCondition(condition: WeatherCondition.Condition.ClearSky, timeOfDay: WeatherCondition.TimeOfDay.Day)
        let forecast = Forecast(hi: 276.32, lo: 274.32, current: 275.32, condition: wc, date: 1483563600.0)

        completion(forecast, nil)
    }
}
