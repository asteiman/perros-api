//
//  Billing.swift
//  App
//
//  Created by Alan Steiman on 20/01/2020.
//

import FluentMySQL
import Vapor
import Pagination

final class Billing: MySQLModel {
    var id: Int?
    
    var customerId: Int
    var month: String
    var year: String
    var white: Float
    var black: Float
    var credit: Float

    init(id: Int? = nil, customerId: Int, month: String, year: String, white: Float, black: Float, credit: Float) {
        self.id = id
        self.customerId = customerId
        self.month = month
        self.year = year
        self.white = white
        self.black = black
        self.credit = credit
    }
}

extension Billing: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(Billing.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.customerId)
            builder.field(for: \.month)
            builder.field(for: \.year)
            builder.field(for: \.white)
            builder.field(for: \.black)
            builder.field(for: \.credit)
        }
    }
}

extension Billing: Content { }

extension Billing: Parameter { }

extension Billing: Paginatable { }
