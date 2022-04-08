//
//  NetworkManager.swift
//  Lesson 2.10
//
//  Created by Kostya on 03.04.2022.
//

import UIKit
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    typealias Handler = (Result<YandexWeather, AFError>) -> Void
    
    private init() {}
    
    func fetchWeather(url: String, completion: @escaping Handler)  {
        let headers = HTTPHeaders(DataManager.shared.keyAPI)
        
        AF.request(url, headers: headers).responseJSON { dataResponse in
            switch dataResponse.result {
            case .success(let value):
                guard let weather = value as? [String: Any] else { return }
                guard let currentDate = weather["now"] as? Double else { return }
                guard let currentWeatherData = weather["fact"] as? [String: Any] else { return }
                guard let forecastsData = weather["forecasts"] as? [[String: Any]] else { return }
                guard let geoObjectData = weather["geo_object"] as? [String: Any] else { return }
                
                let currentWeather = CurrentWeather(with: currentWeatherData)
                let forecasts = self.decodeForecasts(from: forecastsData)
                let geoObject = self.decodeGeoObject(from: geoObjectData)
                
                let yandexWeather = YandexWeather(
                    fact: currentWeather,
                    now: currentDate,
                    forecasts: forecasts,
                    geo_object: geoObject
                )
                
                DispatchQueue.main.async {
                    completion(.success(yandexWeather))
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func decodeForecasts(from forecastsData: [[String: Any]]) -> [Forecasts] {
        var forecasts = [Forecasts]()
        
        for forecast in forecastsData {
            guard let forecastDate = forecast["date_ts"] as? Double else { return [] }
            guard let partsData = forecast["parts"] as? [String: Any] else { return [] }
            guard let dayData = partsData["day"] as? [String: Any] else { return [] }
            let day = Day(from: dayData)
            let parts = Parts(day: day)
            
            forecasts.append(Forecasts(date_ts: forecastDate, parts: parts))
        }
        return forecasts
    }
    
    private func decodeGeoObject(from geoObjectData: [String: Any]) -> GeoObject? {
        guard let localityData = geoObjectData["locality"] as? [String: Any] else { return nil }
        guard let provinceData = geoObjectData["province"] as? [String: Any] else { return nil }
        guard let countryData = geoObjectData["country"] as? [String: Any] else { return nil }

        let locality = Location(from: localityData)
        let province = Location(from: provinceData)
        let country = Location(from: countryData)
        
        return GeoObject(locality: locality, province: province, country: country)
    }
}
