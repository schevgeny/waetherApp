//
//  WeatherResponce.swift
//  weatherApp
//
//  Created by Eugene sch on 10/27/20.
//

import Foundation

class WeatherResponce: Decodable {
    var location: Location
    var current: Current
}
