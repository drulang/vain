//
//  Forecast.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

enum ModelError: Error {
    case SerializationError
}

class Forecast : Model {
    var date:Date
    var hi:NSMeasurement
    var lo:NSMeasurement
    var current:NSMeasurement?
    var condition:WeatherCondition
    
    init(hi:NSMeasurement, lo:NSMeasurement, current:NSMeasurement?, condition:WeatherCondition, date:Date) {
        self.hi = hi
        self.lo = lo
        self.current = current
        self.condition = condition
        self.date = date
    }
    
    convenience init(hi:Double, lo:Double, current:Double?, condition:WeatherCondition, date:Double) {
        let hiMeasurement = NSMeasurement(doubleValue: hi, unit: UnitTemperature.kelvin)
        let loMeasurement = NSMeasurement(doubleValue: lo, unit: UnitTemperature.kelvin)
        var currentMeasurement:NSMeasurement?
        
        if let current = current {
            currentMeasurement = NSMeasurement(doubleValue: current, unit: UnitTemperature.kelvin)
        }
        
        let dateObj = Date(timeIntervalSince1970: date)
        
        self.init(hi:hiMeasurement, lo:loMeasurement, current:currentMeasurement, condition:condition, date:dateObj)
    }
    
    convenience init(withData data:[String:Any]) throws {
        guard let hi = data["hi"] as? Double,
            let lo = data["lo"] as? Double,
            let date = data["datetime"] as? Double
            else {
                throw ModelError.SerializationError
        }
        
        let condition = WeatherCondition(type: WeatherConditionType.ClearSky, timeOfDay: TimeOfDay.Day)
        let current = data["current"] as? Double
        
        self.init(hi: hi, lo:lo, current:current, condition:condition, date:date)
    }
}

class MultiDayForecast : Model {
    var days:[Forecast] = [] //TODO: Evaluate if this should be constant
}
