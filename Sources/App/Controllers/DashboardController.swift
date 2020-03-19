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

    func index(_ req: Request) throws -> Future<[Dashboard]> {
        return req.withPooledConnection(to: .mysql) { conn in
            return conn.raw("SELECT DATE_FORMAT(date, '%Y') AS year, DATE_FORMAT(date, '%m') AS month, COUNT(*) AS count FROM invoice WHERE status=1 GROUP BY year, month ORDER BY year DESC, month ASC")
                .all(decoding: OrderCountResult.self)
                .map { result -> [Dashboard] in
                    var returnArray = [Dashboard]()
                    
                    let years = Array(Set(result.map {$0.year})).sorted(by: >).prefix(5)
                    for year in years {
                        let months = result.filter {$0.year == year}
                        
                        let dashboard = Dashboard(year: year, orders: months.map { month in
                            return Dashboard.OrderPerMonth(month: Int(month.month)!, count: month.count)
                        })
                        
                        returnArray.append(dashboard)
                    }
                    
                    return returnArray
                }
        }
    }
}
