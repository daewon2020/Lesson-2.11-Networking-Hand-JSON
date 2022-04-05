//
//  NetworkManager.swift
//  Lesson 2.10
//
//  Created by Kostya on 03.04.2022.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    init() {}
    
    func fetchWeather(completion: @escaping (_ yandexWeather: YandexWeather) ->()) {
        let urlWeather = DataManager.shared.urlWeather
        let urlWeatherParameters = DataManager.shared.urlWeatherParameters
        let keyAPI = DataManager.shared.keyAPI
        
        guard var urlComponents = URLComponents(string: urlWeather) else { return }
        urlComponents.queryItems = urlWeatherParameters
        
        guard let url = urlComponents.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(keyAPI.first?.value ?? "", forHTTPHeaderField: keyAPI.first?.key ?? "")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let yandexWeather = try JSONDecoder().decode(YandexWeather.self, from: data)
                DispatchQueue.main.async {
                    completion(yandexWeather)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
