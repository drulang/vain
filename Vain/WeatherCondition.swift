//
//  WeatherCondition.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

struct WeatherCondition {
    
    enum Condition : String {
        case ClearSky
        case Clouds
        case Drizzle
        case Rain
        case Snow
        case Thunderstorm
        case Atmosphere
    }
    
    enum TimeOfDay : String {
        case Day
        case Night
    }
    
    static let IconPrefix = "IconWeather"
    let condition:Condition
    let timeOfDay:TimeOfDay
    
    func imageName() -> String {
        return "\(WeatherCondition.IconPrefix)\(condition.rawValue)\(timeOfDay)"
    }
    
    func color() -> UIColor {
        switch condition {
        case .ClearSky:
            return timeOfDay == .Day ? Appearance.Palette.WeatherCondition.ClearSky.Day : Appearance.Palette.WeatherCondition.ClearSky.Night
        case .Thunderstorm:
            return timeOfDay == .Day ? Appearance.Palette.WeatherCondition.Thunderstorm.Day : Appearance.Palette.WeatherCondition.Thunderstorm.Night
        case .Clouds:
            return timeOfDay == .Day ? Appearance.Palette.WeatherCondition.Clouds.Day : Appearance.Palette.WeatherCondition.Clouds.Night
        case .Drizzle:
            return timeOfDay == .Day ? Appearance.Palette.WeatherCondition.Drizzle.Day : Appearance.Palette.WeatherCondition.Drizzle.Night
        case .Rain:
            return timeOfDay == .Day ? Appearance.Palette.WeatherCondition.Rain.Day : Appearance.Palette.WeatherCondition.Rain.Night
        case .Snow:
            return timeOfDay == .Day ? Appearance.Palette.WeatherCondition.Snow.Day : Appearance.Palette.WeatherCondition.Snow.Night
        case .Atmosphere:
            return timeOfDay == .Day ? Appearance.Palette.WeatherCondition.Atmosphere.Day : Appearance.Palette.WeatherCondition.Atmosphere.Night
        }
        
    }
    
    func displayName() -> String {
        switch condition {
        case .ClearSky: return "Clear Sky"
        default: return condition.rawValue.capitalized
        }
    }
    
}

