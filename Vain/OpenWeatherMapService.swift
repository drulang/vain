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
    }
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
        
        let url = try API.Config.BaseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        var urlParameters = result.parameters
        urlParameters.updateValue(API.Config.Credentials.Key, forKey: API.Parameters.APIKey)

        return try URLEncoding.default.encode(urlRequest, with: urlParameters)
    }
}


fileprivate enum OpenWeatherDataHandler : LocalDataAdapter {
    case currentForecast(withData:Any)
    
    func adaptToLocalFormat() -> Any? {
        switch self {
        case let .currentForecast(data):
            let json = JSON(data)
            let forecastJson = json[API.Parameters.CurrentForecast]
            var returnDict:[String:Any] = [:]
            
            returnDict[ParameterForecast.Hi] = forecastJson[API.Parameters.Hi].double
            returnDict[ParameterForecast.Lo] = forecastJson[API.Parameters.Lo].double
            returnDict[ParameterForecast.Current] = forecastJson[API.Parameters.Current].double
            returnDict[ParameterForecast.Date] = json[API.Parameters.Date].double

            return returnDict
        }
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

        completion(forecast, nil)
    }
    
    internal func currentForecast(atLocation location: Location, completion: @escaping (Forecast?, WeatherServiceError?) -> Void) {

        Alamofire.request(Router.currentForecast(location: location)).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let data = OpenWeatherDataHandler.currentForecast(withData: value).adaptToLocalFormat()

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
                print(error)
            }
        }
    }
    
}
