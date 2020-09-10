//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 08.09.2020.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let  dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

private let hourlyFormatter: DateFormatter = {
    let  hourlyFormatter = DateFormatter()
    hourlyFormatter.dateFormat = "ha"
    return hourlyFormatter
}()

class WeatherDetail: WeatherLocation{
    
    //MARK: - Struct
    private struct Result: Codable{
        var timezone: String
        var current: Current
        var daily: [Daily]
        var hourly: [Hourly]
    }
    
   private struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
   private struct Weather:Codable {
        var description: String
        var icon: String
        var id: Int
    }
    
   private struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    private struct Hourly: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
   private struct Temp: Codable {
        var max: Double
        var min: Double
    }
    
//MARK: - Reference
    
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    var timezone = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather] = []
        
//MARK: - Parsing
    
    func getData(completed: @escaping () -> ()){
        let urlString =
        "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=imperial&lang=ua&appid=\(APIKeys.openWeatherKey)"
        print(urlString)
    
    // create a URL
        guard let url = URL(string: urlString) else {
            print("Error: відсутні данні")
        return
        }
    
    // Create session
        let session = URLSession.shared
    
    // Get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error{
            print("ERROR!\(error.localizedDescription)")
            }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dayIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
                for index in 0..<result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekdayDate)
                    let dailyIcon = self.systemNameFromID(id: result.daily[index].weather[0].id, icon: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyHigh = Int(result.daily[index].temp.max.rounded())
                    let dailyLow = Int(result.daily[index].temp.min.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                }
                let lastHour = min(24, result.hourly.count)
                if lastHour > 0 {
                    for index in 0..<result.hourly.count {
                        let hourlyDay = Date(timeIntervalSince1970: result.hourly[index].dt)
                        hourlyFormatter.timeZone = TimeZone(identifier: result.timezone)
                        let hour = hourlyFormatter.string(from: hourlyDay)
                        
                        let hourlyIcon = self.systemNameFromID(id: result.hourly[index].weather[0].id, icon: result.hourly[index].weather[0].icon)
                        let hourlyTemp = Int(result.hourly[index].temp.rounded())
                        let hourlyWeather = HourlyWeather(hour: hour, hourlyTemp: hourlyTemp, hourlyIcon: hourlyIcon)
                        self.hourlyWeatherData.append(hourlyWeather)
                    }
                }
            } catch {
            print("ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume()
    }
    
  // MARK: - Make custom image
    
   private func fileNameForIcon(icon:String) -> String{
        var newFileName = ""
        switch icon {
        case "01d":
            newFileName = "clear-day"
        case"01n":
            newFileName = "clear-night"
        case"02d":
            newFileName = "partly-cloudy-day"
        case "02n":
            newFileName = "partly-cloudy-night"
        case "03d", "03n", "04d", "04n":
            newFileName = "cloudy"
        case "09d", "09n", "10d", "10n":
            newFileName = "rain"
        case "11d", "11n":
            newFileName = "thunderstorm"
        case "13d", "13n":
            newFileName = "snow"
        case "50d", "50n":
            newFileName = "fog"
        default:
            newFileName = ""
        }
        return newFileName
    }
    
 //MARK: Make custom icon
    private func systemNameFromID(id:Int, icon: String) -> String{
        switch id {
        case 200...300:
            return "cloud.bolt.rain"
         case 300...399:
            return "cloud.drizzle"
         case 500, 501, 520, 521, 531:
            return "cloud.rain"
        case 502, 503, 504, 522:
            return "cloud.bolt.rain"
        case 511, 611...616:
            return "sleet"
        case 600...602, 620...622:
            return "snow"
        case 701, 721, 741:
            return "cloud.fog"
        case 711:
            return (icon.hasSuffix("d") ? "sun.haze" : "clod.fog")
        case 731, 751, 761, 762:
            return (icon.hasSuffix("d") ? "sun.dust" : "cloud.fog" )
        case 771:
            return "wind"
        case 781:
            return "tornado"
        case 800:
            return (icon.hasSuffix("d") ? "sun.max" : "moon")
        case 801, 802 :
            return (icon.hasSuffix("d") ? "cloud.sun" : "cloud.moon")
        case 803, 804:
            return "cloud"
        default:
            return "questiomark.diamond"
        }
    }
}
