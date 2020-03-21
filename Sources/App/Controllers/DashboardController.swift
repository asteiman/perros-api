//
//  DashboardController.swift
//  App
//
//  Created by Alan Steiman on 19/03/2020.
//

import Foundation
import Vapor
import FluentMySQL

final class DashboardController {

    func index(_ req: Request) throws -> Future<Dashboard> {
        return req.withPooledConnection(to: .mysql) { conn in
            return conn.raw("SELECT DATE_FORMAT(date, '%Y') AS year, DATE_FORMAT(date, '%m') AS month, COUNT(*) AS count FROM invoice WHERE status=1 GROUP BY year, month ORDER BY year DESC, month ASC")
                .all(decoding: OrderCountDatabaseResult.self)
                .map { result -> [OrdersPerYear] in
                    var returnArray = [OrdersPerYear]()
                    
                    let years = Array(Set(result.map {$0.year})).sorted(by: >).prefix(5)
                    for year in years {
                        let months = result.filter {$0.year == year}
                        
                        let dashboard = OrdersPerYear(year: year, orders: months.map { month in
                            return OrdersPerYear.OrderPerMonth(month: Int(month.month)!, count: month.count)
                        })
                        
                        returnArray.append(dashboard)
                    }
                    
                    return returnArray
            }
        }.flatMap { ordersPerYear in
            return req.withPooledConnection(to: .mysql) { conn in
                return conn.raw("SELECT C.id as id, C.name, SUM(white) + SUM(black) - SUM(credit) as total FROM customer C INNER JOIN billing on C.id=billing.customerId GROUP BY C.id ORDER BY total DESC LIMIT 5")
                .all(decoding: CustomerBilling.self)
            }.map { customerBilling -> Dashboard in
                return Dashboard(orders: ordersPerYear, customers: customerBilling)
            }
        }
    }
}
