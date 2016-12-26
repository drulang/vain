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
            static let Key = "36ddc8780ce4c36953b60d7c8e2d70d6" //TODO: Move into plist
        }
    }
    
    struct Parameters {
        static let CurrentForecast = "main"
        static let APIKey = "appid"
        static let Hi = "temp_max"
        static let Lo = "temp_min"
        static let Current = "temp"
        static let Date = "dt"
        static let Location = "q"
        static let Count = "cnt"
        static let ID = "id"
        static let WeatherCondition = "weather"
        static let DailyWeatherList = "list"
    }
}


fileprivate enum Router : URLRequestConvertible {
    case currentForecast(location:Location)
    case dailyForecast(location:Location, numberOfDays:UInt)
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case .currentForecast(_):
                let parameters = [
                    API.Parameters.Location : "London"
                ]
                return ("/weather", parameters)
                
            case let .dailyForecast(_, numberOfDays):
                let parameters = [
                    API.Parameters.Location: "London",
                    API.Parameters.Count: numberOfDays
                    ] as [String : Any]
                
                return ("/forecast/daily", parameters)
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
            let json = JSON(foreignData)
            let forecastJson = json[API.Parameters.CurrentForecast]
            var returnDict:[String:Any] = [:]

            returnDict[ParameterForecast.Hi] = forecastJson[API.Parameters.Hi].double
            returnDict[ParameterForecast.Lo] = forecastJson[API.Parameters.Lo].double
            returnDict[ParameterForecast.Current] = forecastJson[API.Parameters.Current].double
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
            return nil
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
    
    internal func dailyForecast(atLocation location: Location, numberOfDays: UInt, completion: @escaping (DailyForecast?, WeatherServiceError?) -> Void) {
        Alamofire.request(Router.dailyForecast(location: Location(), numberOfDays: 5)).responseJSON { (response) in
            
            
            
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
                        completion(nil, WeatherServiceError.DataSerializationError)
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
