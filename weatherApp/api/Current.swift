//
//  Current.swift
//  weatherApp
//
//  Created by Eugene sch on 10/27/20.
//

import Foundation

class Current: Decodable {
    var observation_time: String?
    var temperature: Int?
    var weather_code: Int?
    var weather_icons: [String]?
    var weather_descriptions: [String]?
    var wind_speed: Int?
    var wind_degree: Int?
    var is_day: String?
    var visibility: Int?
    var humidity: Int?
    var precip: Float?
}
