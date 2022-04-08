//
//  WeatherModel.swift
//  Lesson 2.10
//
//  Created by Kostya on 03.04.2022.
//

import Foundation

struct YandexWeather: Decodable {
    let fact: CurrentWeather?
    let now: Double?
    let forecasts: [Forecasts]?
    let geo_object: GeoObject?
}

struct GeoObject: Decodable {
    let locality: Location?
    let province: Location?
    let country: Location?
}

struct Location: Decodable {
    let name: String?
    
    init(from dataResponse: [String: Any]) {
        name = dataResponse["name"] as? String
    }
}

struct CurrentWeather: Decodable {
    let temp: Int?
    let feels_like: Int?
    let icon: String?
    let wind_speed: Int?
    let pressure_mm: Int?
    let humidity: Int?
    
    var windString: String {
        "\(wind_speed ?? 0) м.с."
    }
    var pressureString: String {
        "\(pressure_mm ?? 0) мм. рт. ст"
    }
    var humidityString: String {
        "\(humidity ?? 0)%"
    }
    
    init(with dataResponse: [String: Any]) {
        temp = dataResponse["temp"] as? Int
        feels_like = dataResponse["feels_like"] as? Int
        icon = dataResponse["icon"] as? String
        wind_speed = dataResponse["wind_speed"] as? Int
        pressure_mm = dataResponse["pressure_mm"] as? Int
        humidity = dataResponse["humidity"] as? Int
    }
    
}

struct Forecasts: Decodable {
    let date_ts: Double?
    let parts: Parts?
}

struct Parts: Decodable {
    let day: Day?
}

struct Day: Decodable {
    let temp_avg: Int?
    let icon: String?
    
    init(from dateResponse: [String: Any]) {
        temp_avg = dateResponse["temp_avg"] as? Int
        icon = dateResponse["icon"] as? String
    }
}

