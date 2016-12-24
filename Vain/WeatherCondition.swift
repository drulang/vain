//
//  WeatherCondition.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

enum WeatherConditionType : String {
    case ClearSky = "Clear Sky"
}

enum TimeOfDay : String {
    case Day = "Day"
    case Night = "Night"
}

private struct WeatherConditionConfig {
    static let IconPrefix = "IconWeather"
}


class WeatherCondition: Model {

    let type:WeatherConditionType
    let timeOfDay:TimeOfDay
    
    // Computed properties
    var name:String {
        get { return name(withType: type) }
    }

    var imageAssetName:String {
        get { return imageName(withType: type, timeOfDay: timeOfDay) }
    }
    var color:UIColor {
        get { return color(withType: type) }
    }
    
    
    // Constructors
    init(type:WeatherConditionType, timeOfDay:TimeOfDay) {
        self.type = type
        self.timeOfDay = timeOfDay
    }

}


// MARK: Helpers
extension WeatherCondition {
    
    fileprivate func name(withType type:WeatherConditionType) -> String {
        return self.type.rawValue.capitalized
    }
    
    fileprivate func imageName(withType type:WeatherConditionType, timeOfDay:TimeOfDay) -> String {
        return "\(WeatherConditionConfig.IconPrefix)\(type.rawValue)\(timeOfDay)"
    }

    fileprivate func color(withType type:WeatherConditionType) -> UIColor {
        return UIColor.clear
    }
    
}
