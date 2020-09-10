//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 8/20/20.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import Foundation

class NetworkManager{
  
    private init(){}
    
    static let shared:NetworkManager = NetworkManager()
    
    func getWeatherInfo(city: String, result: @escaping ((WeatherModel?) -> ())) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: city), URLQueryItem(name: "appid", value: "81ce47c3bcfb35354cd56be9bcb51c98")]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if error == nil{
                let decoder =   JSONDecoder()
                var decoderOfferModel:WeatherModel?
                if data != nil{
                    decoderOfferModel = try? decoder.decode(WeatherModel.self, from: data!)
                }
                result(decoderOfferModel)
            } else {
                print(error)
            }
        }.resume()
    }
}
