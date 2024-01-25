//
//  Date+Extensions.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 25/01/24.
//

import Foundation

extension Date {
    func getFormattedDateString(dateFormat: String = "d MMM yyyy",
                                dateStyle: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
    
    func getFormattedTimeString(dateFormat: String = "h:mm a",
                                dateStyle: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
}
