//
//  Date+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 20/02/24.
//

import Foundation

extension Date {
    static func customDate(year: Int = 2023,
                           month: Int = 1,
                           day: Int = 1,
                           hour: Int = 1,
                           minute: Int = 1,
                           second: Int = 1) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

        return Calendar.current.date(from: dateComponents)
    }
    
    func add(_ value: Int, to component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
}
