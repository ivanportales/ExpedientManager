//
//  CalendarExtension.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 09/11/24.
//

import Foundation

extension Calendar {
    func combineTimeFrom(_ firstDate: Date, andDateFrom secondDate: Date) -> Date {
        let firstTimeComponents = self.dateComponents([.hour, .minute, .second], from: firstDate)
        return self.date(bySettingHour: firstTimeComponents.hour ?? 0,
                         minute: firstTimeComponents.minute ?? 0,
                         second: firstTimeComponents.second ?? 0,
                         of: secondDate)!
    }
    
    func isDate(_ firstDate: Date, before secondDate: Date) -> Bool {
        return firstDate.compare(secondDate) == .orderedAscending
    }

    
    func isDate(_ firstDate: Date, inSameDayOrAfter secondDate: Date) -> Bool {
        return !isDate(firstDate, before: secondDate)
    }
    
    func add(_ value: Int, to component: Calendar.Component, ofDate date: Date) -> Date {
        return self.date(byAdding: component, value: value, to: date)!
    }
    
    func getWeekDayDescriptionFrom(date : Date) -> String {
        let dayIndex = self.component(.weekday, from: date)
        return self.weekdaySymbols[dayIndex]
    }
    
    func getDescriptionOf(date: Date) -> String {
        let components = self.dateComponents([.weekday, .day, .month, .hour, .minute], from: date)
        
        guard let weekDayIndex = components.weekday, 
              let monthIndex = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute else {
            return "Invalid Date"
        }

        let weekDayDescription = self.weekdaySymbols[weekDayIndex - 1].capitalized
        let monthDescription = self.monthSymbols[monthIndex - 1]
        
        let ofConnective = NSLocalizedString("of", comment: "")
        let atConnective = NSLocalizedString("at", comment: "")
        
        return "\(weekDayDescription), \(day) \(ofConnective) \(monthDescription) \(atConnective) \(hour):\(minute)"
    }

    
    func getHourAndMinuteFrom(date : Date) -> String {
        let hour = self.component(.hour, from: date)
        let minute = self.component(.minute, from: date)
        
        return String(format: "%02d:%02d", hour,minute)
    }
    
    func getDayAndMonthFrom(date : Date) -> String {
        let day = self.component(.day, from: date)
        let month = self.component(.month, from: date)
        
        return String(format: "%02d/%02d", day,month)
    }
    
    func getMonthDescriptionOf(date: Date) -> String {
        let month = self.component(.month, from: date)
        return self.monthSymbols[month - 1]
    }
}
