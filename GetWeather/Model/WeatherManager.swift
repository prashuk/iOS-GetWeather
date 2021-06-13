//
//  WeatherManager.swift
//  GetWeather
//
//  Created by Prashuk Ajmera on 6/11/21.
//

import Foundation

// MARK:- Protocol Weather Manager Delegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithErorr(error: Error)
}

// MARK:- Weather Manager
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=16675cf9fd414df493e2dd9e97b2d86e&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String?) {
        if let urlStr = urlString {
            let url = URL(string: urlStr)!
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithErorr(error: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print(String(describing: response))
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseWeatherData(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            
            task.resume()
        }
    }
    
    func parseWeatherData(_ weatherdata: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherdata)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithErorr(error: error)
            return nil
        }
    }
}
