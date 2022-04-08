//
//  DataManager.swift
//  Lesson 2.10
//
//  Created by Kostya on 04.04.2022.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    let keyAPI = ["X-Yandex-API-Key": "7a39c9aa-d4d7-4c79-be43-2b668b05a140"]
    let urlWeather = "https://api.weather.yandex.ru/v2/forecast?lang=ru_RU&limit=7&hours=false&extra=true"
    private init () {}
}
