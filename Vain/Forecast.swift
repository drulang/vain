//
//  Forecast.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

class Forecast : Model {
    var date:Date?
    var hi:UnitTemperature?
    var lo:UnitTemperature?
    var condition:WeatherCondition?
}

class MultiDayForecast : Model {
    var days:[Forecast] = [] //TODO: Evaluate if this should be constant
}
