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
        return getOrders(req)
            .and(getCustomers(req))
            .map { ($0, $1) }
            .and(getTotalBilling(req)).map { result, totalBilling in
                return Dashboard(orders: result.0, customers: result.1, billing: totalBilling)
            }
    }
    
    private func getTotalBilling(_ req: Request) -> Future<[BillingResponse]> {
        return req.withPooledConnection(to: .mysql) { conn in
            return conn.raw("SELECT year, SUM(white) + SUM(black) - SUM(credit) as total FROM billing GROUP BY year ORDER BY year DESC LIMIT 5")
            .all(decoding: BillingResponse.self)
        }
    }
    
    private func getCustomers(_ req: Request) -> Future<[CustomerBilling]> {
        return req.withPooledConnection(to: .mysql) { conn in
            return conn.raw("SELECT billing.year, C.id as id, C.name, SUM(billing.white) + SUM(billing.black) - SUM(billing.credit) as total FROM customer C INNER JOIN billing on C.id=billing.customerId GROUP BY C.id, billing.year ORDER BY year DESC, total desc")
            .all(decoding: CustomerBilling.self)
                .map { result in
                    var returnArray = [CustomerBilling]()
                    
                    let years = Array(Set(result.map {$0.year})).sorted(by: >).prefix(5)
                    for year in years {
                        returnArray.append(contentsOf: result.filter {$0.year == year}.prefix(5))
                    }
                    
                    return returnArray
            }
        }
    }
    
    private func getOrders(_ req: Request) -> Future<[OrdersPerYear]> {
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
        }
    }
}
