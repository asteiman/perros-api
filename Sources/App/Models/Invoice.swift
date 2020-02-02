//
//  Invoice.swift
//  App
//
//  Created by Alan Steiman on 21/01/2020.
//

import FluentMySQL
import Vapor
import Pagination

final class Invoice: MySQLModel {
    var id: Int?
    
    var date: Date
    var status: Int
    var customerId: Customer.ID

    init(id: Int? = nil, date: Date, status: Int, customerId: Customer.ID) {
        self.id = id
        self.date = date
        self.status = status
        self.customerId = customerId
    }
}

extension Invoice: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(Invoice.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.date)
            builder.field(for: \.status)
            builder.field(for: \.customerId)
        }
    }
}

extension Invoice: Content { }

extension Invoice: Parameter { }

extension Invoice: Paginatable { }
