//
//  Date+Extensions.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 25/01/24.
//

import Foundation

extension Date {
    func formateDate(withFormat format: String = "d MMM yyyy",
                     dateStyle: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func formatTime(withFormat format: String = "h:mm a",
                    timeStyle: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = timeStyle
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
