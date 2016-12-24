//
//  OpenWeatherMapService.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation
import Alamofire

fileprivate struct APIConfig {
    static let BaseURLString = "http://api.openweathermap.org/data/2.5"
    static let Key = "36ddc8780ce4c36953b60d7c8e2d70d6" //TODO: Move into plist
    static let KeyParameter = "appid"
}

fileprivate struct APIParameters {
    static let Location = "q"
    static let Count = "cnt"
}

fileprivate enum Router : URLRequestConvertible {
    case currentForecast(location:Location)
    case dailyForecast(location:Location, numberOfDays:UInt)
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case .currentForecast(_):
                let parameters = [
                    APIParameters.Location : "London"
                ]
                return ("/weather", parameters)
                
            case let .dailyForecast(_, numberOfDays):
                let parameters = [
                    APIParameters.Location: "London",
                    APIParameters.Count: numberOfDays
                    ] as [String : Any]
                
                return ("/forecast/daily", parameters)
            }
        }()
        
        let url = try APIConfig.BaseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        var urlParameters = result.parameters
        urlParameters.updateValue(APIConfig.Key, forKey: APIConfig.KeyParameter)

        return try URLEncoding.default.encode(urlRequest, with: urlParameters)
    }
}

class OpenWeatherMapService {
    
}


//MARK: WeatherDataSource
extension OpenWeatherMapService: WeatherServiceDataSource {
    
    // TODO: Change this to a daily forecast that takes the number of days as a param
    internal func fiveDayForecast(atLocation location: Location, completion: (MultiDayForecast?, WeatherServiceError?) -> Void) {
        
        Alamofire.request(Router.dailyForecast(location: Location(), numberOfDays: 5)).responseJSON { (response) in
            
        }

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
        Alamofire.request(Router.currentForecast(location: Location())).responseJSON { (response: DataResponse) in

        }
        
        forecast.date = Date()
        forecast.current = NSMeasurement(doubleValue: 75, unit: UnitTemperature.fahrenheit)
        forecast.hi = NSMeasurement(doubleValue: 74, unit: UnitTemperature.fahrenheit)
        forecast.lo = NSMeasurement(doubleValue: 60, unit: UnitTemperature.fahrenheit)
        
        completion(forecast, nil)
    }
    
}
