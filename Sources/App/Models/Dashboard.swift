//
//  Dashboard.swift
//  App
//
//  Created by Alan Steiman on 19/03/2020.
//

import Foundation
import Vapor

struct OrderCountResult: Encodable, Content {
    var year: String
    var month: String
    var count: Int
}

struct Dashboard: Codable, Content {
    var year: String
    var orders: [OrderPerMonth]
    
    struct OrderPerMonth: Codable {
        var month: Int
        var count: Int
    }
}
