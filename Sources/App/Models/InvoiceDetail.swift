//
//  InvoiceDetail.swift
//  App
//
//  Created by Alan Steiman on 21/01/2020.
//

import FluentMySQL
import Vapor
import Pagination

final class InvoiceDetail: MySQLModel {
    var id: Int?
    
    var invoiceId: Invoice.ID
    var productId: Product.ID
    var quantity: Int
    var description: String

    init(id: Int? = nil, invoiceId: Invoice.ID, productId: Product.ID, quantity: Int, description: String) {
        self.id = id
        self.invoiceId = invoiceId
        self.productId = productId
        self.quantity = quantity
        self.description = description
    }
}

extension InvoiceDetail: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(InvoiceDetail.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.invoiceId)
            builder.field(for: \.productId)
            builder.field(for: \.quantity)
            builder.field(for: \.description)
        }
    }
}

extension InvoiceDetail: Content { }

extension InvoiceDetail: Parameter { }

extension InvoiceDetail: Paginatable { }
