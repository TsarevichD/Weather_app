//
//  Current.swift
//  weather_App
//
//  Created by MacBook on 08/10/2023.
//

import Foundation

struct CurrentResponse: Codable {
    let location: Location
    let current: Current
}
