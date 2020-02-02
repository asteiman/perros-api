//
//  Product.swift
//  App
//
//  Created by Alan Steiman on 21/01/2020.
//

import FluentMySQL
import Vapor
import Pagination

final class Product: MySQLModel {
    var id: Int?
    
    var code: String
    var description: String
    var price: Float

    init(id: Int? = nil, code: String, description: String, price: Float) {
        self.id = id
        self.code = code
        self.description = description
        self.price = price
    }
}

extension Product: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(Product.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.code)
            builder.field(for: \.description)
            builder.field(for: \.price)
        }
    }
}

extension Product: Content { }

extension Product: Parameter { }

extension Product: Paginatable { }
