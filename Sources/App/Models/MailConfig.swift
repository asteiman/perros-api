//
//  MailConfig.swift
//  App
//
//  Created by Alan Steiman on 21/01/2020.
//

import FluentMySQL
import Vapor
import Pagination

final class MailConfig: MySQLModel {
    var id: Int?
    
    var subject: String
    var fromName: String
    var fromEmail: String
    var toEmail: String

    init(id: Int? = nil, subject: String, fromName: String, fromEmail: String, toEmail: String) {
        self.id = id
        self.subject = subject
        self.fromName = fromName
        self.fromEmail = fromEmail
        self.toEmail = toEmail
    }
}

extension MailConfig: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(MailConfig.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.subject)
            builder.field(for: \.fromName)
            builder.field(for: \.fromEmail)
            builder.field(for: \.toEmail)
        }
    }
}

extension MailConfig: Content { }

extension MailConfig: Parameter { }

extension MailConfig: Paginatable { }
