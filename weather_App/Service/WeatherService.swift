//
//  WeatherService.swift
//  weather_App
//
//  Created by MacBook on 07/10/2023.
//
import Foundation
import Alamofire

enum WeatherServiceError: Error {
    case unknown
    case noData
}

class WeatherService {
    
    static let shared = WeatherService()
    
    private init() {}
    
    private let weatherBaseUrl = "http://api.weatherapi.com/v1"
    private let weatherForecastPath = "/forecast.json"
    private let weatherCurrentPath = "/current.json"
    private let daysForecastPath = 10
    private let weatherAPIKey = "eafcefffff434478ba4164456230610"
    
    func getWeathers(cityName: String, successCompletion: @escaping (ForecastResponse) -> Void, errorComletion: @escaping (Error) -> Void) {
        
        let url = "\(weatherBaseUrl)\(weatherForecastPath)?key=\(weatherAPIKey)&q=\(cityName)&days=\(daysForecastPath)&aqi=no&alerts=no"
        AF.request(url)
            .validate()
            .responseDecodable(of: ForecastResponse.self) { response in
                switch response.result {
                case let .success(forecastResponse):
                    successCompletion(forecastResponse)
                case let .failure(error):
                    errorComletion(error)
                    print(error)
                }
            }
    }
    
    func getCurrentWeather(cityName: String, successCompletion: @escaping (CurrentResponse) -> Void, errorComletion: @escaping (Error) -> Void) {
        
        let url = "\(weatherBaseUrl)\(weatherCurrentPath)?key=\(weatherAPIKey)&q=\(cityName)&aqi=no"
        AF.request(url)
            .validate()
            .responseDecodable(of: CurrentResponse.self) { response in
                switch response.result {
                case let .success(currentResponse):
                    successCompletion(currentResponse)
                case let .failure(error):
                    errorComletion(error)
                    print(error)
            }
        }
    }
}
