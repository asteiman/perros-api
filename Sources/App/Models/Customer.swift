//
//  Customer.swift
//  App
//
//  Created by Alan Steiman on 20/01/2020.
//

import FluentMySQL
import Vapor
import Pagination

/// A single Customer
final class Customer: MySQLModel {
    /// The unique identifier for this `Customer`.
    var id: Int?
    
    var name: String
    var address: String
    var cuit: String
    var iva: Int?
    var phone: String

    /// Creates a new `Customer`.
    init(id: Int? = nil, name: String, address: String, cuit: String, iva: Int, phone: String) {
        self.id = id
        self.name = name
        self.address = address
        self.cuit = cuit
        self.iva = iva
        self.phone = phone
    }
}

/// Allows `Customer` to be used as a Fluent migration.
extension Customer: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(Customer.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name)
            builder.field(for: \.address)
            builder.field(for: \.cuit)
            builder.field(for: \.iva)
            builder.field(for: \.phone)
        }
    }
}

/// Allows `Customer` to be encoded to and decoded from HTTP messages.
extension Customer: Content { }

/// Allows `Customer` to be used as a dynamic parameter in route definitions.
extension Customer: Parameter { }

extension Customer: Paginatable { }
