//
//  WeatherManager.swift
//  Clima
//
//  Created by Giorgi Shukakidze on 12/31/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(Keys.weatherAppId)&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(temperature: temp, conditionId: id, cityName: name)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
