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
}

struct CurrentWeather: Decodable {
    let temp: Int?
    let feels_like: Int?
    let condition: String?
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
    let condition: String?
}

