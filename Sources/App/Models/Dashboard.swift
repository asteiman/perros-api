//
//  Dashboard.swift
//  App
//
//  Created by Alan Steiman on 19/03/2020.
//

import Foundation
import Vapor

struct OrderCountDatabaseResult: Encodable, Content {
    var year: String
    var month: String
    var count: Int
}

struct OrdersPerYear: Codable, Content {
    var year: String
    var orders: [OrderPerMonth]
    
    struct OrderPerMonth: Codable {
        var month: Int
        var count: Int
    }
}

struct Dashboard: Codable, Content {
    var orders: [OrdersPerYear]
    var customers: [CustomerBilling]
    var billing: [BillingResponse]
}

struct CustomerBilling: Codable {
    var id: Int
    var year: String
    var name: String
    var total: Double
}

struct BillingResponse: Codable {
    var year: String
    var total: Double
}
