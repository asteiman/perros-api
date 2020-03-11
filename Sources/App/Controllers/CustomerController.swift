//
//  CustomerController.swift
//  App
//
//  Created by Alan Steiman on 20/01/2020.
//

import Vapor
import FluentMySQL
import Pagination
import Mailgun

/// Simple todo-list controller.
final class CustomerController {

    func index(_ req: Request) throws -> Future<[Customer]> {
        return Customer.query(on: req).sort(\.id).all()
    }
    
    func mail(_ req: Request) throws -> Future<Response> {
        
        let message = Mailgun.Message(
            from: "asteiman@gmail.com",
            to: "asteiman@gmail.com",
            subject: "Newsletter",
            text: "This is a newsletter",
            html: "<h1>This is a newsletter</h1>"
        )

        let mailgun = try req.make(Mailgun.self)
        let config = Mailgun.DomainConfig("sandboxea413acb5afb442b90b7639c7e8a68c9.mailgun.org", region: .us)
        
        return try mailgun.send(message, domain: config, on: req)
    }
    
    func billing(_ req: Request) throws -> Future<[Billing]> {
        let customerId = try req.parameters.next(Int.self)
        
        return Billing.query(on: req).filter(\.customerId == customerId).sort(\.id, ._ascending).all()
    }
    
    func invoice(_ req: Request) throws -> Future<[Invoice]> {
        let customerId = try req.parameters.next(Int.self)
        
        return Invoice.query(on: req).filter(\.customerId == customerId).sort(\.id, ._ascending).all()
    }
}
