//
//  OpenWeatherMapService.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

fileprivate struct API {
    struct Config {
        static let BaseURLString = "http://api.openweathermap.org/data/2.5" //TODO: Move into plist
        
        struct Credentials {
            static let Key = "7d037b6474f28d73e1f202936a68065c" //TODO: Move into plist
        }
    }
    
    struct Parameters {
        struct CurrentForecastTemperature {
            static let Hi = "temp_max"
            static let Lo = "temp_min"
            static let Current = "temp"
        }

        struct DailyForecastTemperature {
            static let Hi = "max"
            static let Lo = "min"
        }

        static let CurrentForecast = "main"
        static let DailyForecast = "temp"
        static let APIKey = "appid"
        static let Date = "dt"
        static let Location = "q"
        static let Count = "cnt"
        static let ID = "id"
        static let WeatherCondition = "weather"
        static let DailyWeatherList = "list"
    }
    
    struct Path {
        static let CurrentForecast = "/weather"
        static let DailyForecast = "/forecast/daily"
    }
}


fileprivate enum Router : URLRequestConvertible {
    case currentForecast(location:Location)
    case dailyForecast(location:Location, numberOfDays:UInt)
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .currentForecast(location):
                let parameters = [
                    API.Parameters.Location : location.displayName
                ]
                return (API.Path.CurrentForecast, parameters)
                
            case let .dailyForecast(location, numberOfDays):
                let parameters = [
                    API.Parameters.Location: location.displayName as Any,
                    API.Parameters.Count: numberOfDays
                    ] as [String : Any]
                
                return (API.Path.DailyForecast, parameters)
            }
        }()
        
        let url = try API.Config.BaseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        var urlParameters = result.parameters
        urlParameters.updateValue(API.Config.Credentials.Key, forKey: API.Parameters.APIKey)

        return try URLEncoding.default.encode(urlRequest, with: urlParameters)
    }
}


fileprivate enum OpenWeatherDataHandler : LocalDataAdapter {
    case currentForecast
    case dailyForecast

    func adaptToLocalFormat(foreignData: Any) -> Any? {
        switch self {
        case .currentForecast:
            var json:JSON
            if foreignData is JSON {
                json = foreignData as! JSON
            } else {
                json = JSON(foreignData)
            }

            let forecastJson = json[API.Parameters.CurrentForecast]
            var returnDict:[String:Any] = [:]

            returnDict[ParameterForecast.Hi] = forecastJson[API.Parameters.CurrentForecastTemperature.Hi].double
            returnDict[ParameterForecast.Lo] = forecastJson[API.Parameters.CurrentForecastTemperature.Lo].double
            returnDict[ParameterForecast.Current] = forecastJson[API.Parameters.CurrentForecastTemperature.Current].double
            returnDict[ParameterForecast.Date] = json[API.Parameters.Date].double

            var weatherConditionType:WeatherConditionType?
            if let weatherConditionId = extractWeatherConditionId(weatherConditions: json[API.Parameters.WeatherCondition]) {
                weatherConditionType = adaptWeatherCondition(id: weatherConditionId)
            } else {
                log.warning("Unable to map the current forecast weather condition type")
            }

            returnDict[ParameterForecast.WeatherCondition] = weatherConditionType?.rawValue

            return returnDict
            
        case .dailyForecast:
            var json:JSON
            if foreignData is JSON {
                json = foreignData as! JSON
            } else {
                json = JSON(foreignData)
            }
            
            let temperatureJSON = json[API.Parameters.DailyForecast]
            
            var returnDict:[String:Any] = [:]
            
            returnDict[ParameterForecast.Hi] = temperatureJSON[API.Parameters.DailyForecastTemperature.Hi].double
            returnDict[ParameterForecast.Lo] = temperatureJSON[API.Parameters.DailyForecastTemperature.Lo].double
            returnDict[ParameterForecast.Date] = json[API.Parameters.Date].double
            
            var weatherConditionType:WeatherConditionType?
            if let weatherConditionId = extractWeatherConditionId(weatherConditions: json[API.Parameters.WeatherCondition]) {
                weatherConditionType = adaptWeatherCondition(id: weatherConditionId)
            } else {
                log.warning("Unable to map the current forecast weather condition type")
            }
            returnDict[ParameterForecast.WeatherCondition] = weatherConditionType?.rawValue

            return returnDict
        }
    }
    
    /** 
     Helper to map the weather condition id's to local WeatherConditionType

     https://openweathermap.org/weather-conditions
     */
    func adaptWeatherCondition(id:UInt) -> WeatherConditionType? {
        switch id {
        case 800 ... 899: return WeatherConditionType.ClearSky
        default: return nil
        }
    }
    
    /**
     Extract the first weather condition id.
     
     Example of expected JSON format:
        "weather": [
            {
                "id": 500,
                "main": "Rain",
                "description": "light rain",
                "icon": "10d"
            }
        ],
     */
    func extractWeatherConditionId(weatherConditions:JSON) -> UInt? {
        return weatherConditions[0][API.Parameters.ID].uInt
    }
}


class OpenWeatherMapService {
    
}


//MARK: WeatherDataSource
extension OpenWeatherMapService: WeatherServiceDataSource {
    
    internal func dailyForecast(atLocation location: Location, numberOfDays: Int, completion: @escaping (DailyForecast?, WeatherServiceError?) -> Void) {
        guard numberOfDays > 0 else {
            log.warning("Attempting to fetch an empty forecast...")
            completion(nil, WeatherServiceError.ParameterError)
            return
        }
        
        Alamofire.request(Router.dailyForecast(location: location, numberOfDays: 5)).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                var days:[Forecast] = []
                
                let json = JSON(value)
                
                for (_, forecastSubJson):(String, JSON) in json[API.Parameters.DailyWeatherList] {
                    let convertedData = OpenWeatherDataHandler.dailyForecast.adaptToLocalFormat(foreignData: forecastSubJson)
                    
                    if let convertedData = convertedData as? [String:Any] {
                        do {
                            let forecast = try Forecast(withData: convertedData) //TODO: Wrap
                            days.append(forecast)
                        } catch {
                            completion(nil, WeatherServiceError.DataSerializationError)
                        }
                    } else {
                        log.error("Received an unexpected format while adapting OpenWeatherData")
                    }
                }
                
                if days.count != numberOfDays {
                    log.warning("Expected to build forecast with a total of \(numberOfDays), but ended with \(days.count)")
                }
                
                let forecast = DailyForecast()
                forecast.days = days
                
                completion(forecast, nil)
            case .failure(let error):
                log.error(error)
                completion(nil, WeatherServiceError.UnavailableError)
                
            }
        }
    }

    
    internal func currentForecast(atLocation location: Location, completion: @escaping (Forecast?, WeatherServiceError?) -> Void) {

        Alamofire.request(Router.currentForecast(location: location)).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let data = OpenWeatherDataHandler.currentForecast.adaptToLocalFormat(foreignData: value)

                if let data = data as? [String:Any] {
                    do {
                        let forecast = try Forecast(withData: data)
                        completion(forecast, nil)
                    } catch {
                        completion(nil, WeatherServiceError.DataSerializationError)  //TODO: Investigate using defer
                    }
                } else {
                    completion(nil, WeatherServiceError.DataSerializationError)
                }
            case .failure(let error):
                log.error(error)
                completion(nil, WeatherServiceError.UnavailableError)
            }
        }
    }
    
}
