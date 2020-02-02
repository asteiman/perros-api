//
//  InvoiceController.swift
//  App
//
//  Created by Alan Steiman on 24/01/2020.
//

import Vapor
import FluentMySQL
import Pagination

final class InvoiceController {

    func index(_ req: Request) throws -> Future<Paginated<Invoice>> {
        return try Invoice.query(on: req).sort(\.id, ._ascending).paginate(for: req)
    }
    
    func single(_ req: Request) throws -> Future<Invoice> {
        return try req.parameters.next(Invoice.self)
    }
}
