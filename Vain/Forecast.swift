//
//  Forecast.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation


struct ParameterForecast {
    static let Hi = "hi"
    static let Lo = "lo"
    static let Date = "date"
    static let Current = "current"
    static let WeatherCondition = "weather_condition_type"
}


enum WeatherForecastType: Int {
    case FiveDay = 5
    case SevenDay = 7
}


class Forecast : Model {
    var date:Date
    var hi:Measurement<Unit>
    var lo:Measurement<Unit>
    var current:Measurement<Unit>?
    var condition:WeatherCondition

    
    init(hi:Measurement<Unit>, lo:Measurement<Unit>, current:Measurement<Unit>?, condition:WeatherCondition, date:Date) {
        self.hi = hi
        self.lo = lo
        self.current = current
        self.condition = condition
        self.date = date
    }
    
    convenience init(hi:Double, lo:Double, current:Double?, condition:WeatherCondition, date:Double) {
        let hiMeasurement = Measurement<Unit>(value: hi, unit: UnitTemperature.kelvin)
        let loMeasurement = Measurement<Unit>(value: lo, unit: UnitTemperature.kelvin)
        var currentMeasurement:Measurement<Unit>?
        
        if let current = current {
            currentMeasurement = Measurement<Unit>(value: current, unit: UnitTemperature.kelvin)
        }
        
        let dateObj = Date(timeIntervalSince1970: date)
        
        self.init(hi:hiMeasurement, lo:loMeasurement, current:currentMeasurement, condition:condition, date:dateObj)
    }
    
    convenience init(withData data:[String:Any]) throws {
        guard let hi = data[ParameterForecast.Hi] as? Double,
             let lo = data[ParameterForecast.Lo] as? Double,
            let date = data[ParameterForecast.Date] as? Double,
            let weatherConditionCode = data[ParameterForecast.WeatherCondition] as? String,
            let condition = WeatherCondition.Condition(rawValue: weatherConditionCode)
            
            else {
                throw ModelError.SerializationError
        }
  
        let weatherCondition = WeatherCondition(condition: condition, timeOfDay: .Day)
        let current = data[ParameterForecast.Current] as? Double

        self.init(hi: hi, lo:lo, current:current, condition:weatherCondition, date:date)
    }
}

class DailyForecast : Model {
    var days:[Forecast] = [] //TODO: Evaluate if this should be constant
}
