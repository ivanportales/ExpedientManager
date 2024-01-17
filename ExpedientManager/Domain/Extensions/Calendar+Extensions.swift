//
//  CalendarExtension.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 09/11/24.
//

import Foundation

extension Calendar {
    func combineTimeFrom(date firstDate: Date, andDateFrom secondDate: Date) -> Date {
        let firstDateComponents = self.dateComponents([.hour, .minute,.second], from: firstDate)
        
        var newDate = self.date(from: firstDateComponents)!
        newDate = self.date(bySettingHour: firstDateComponents.hour!, minute: firstDateComponents.minute!, second: firstDateComponents.second!, of: secondDate)!
        
        return newDate
    }
    
    func isDate(date firstDate: Date, before secondDate: Date) -> Bool? {
        let firstDateComponents = self.dateComponents([.weekOfYear, .month,.weekday, .year, .day], from: firstDate)
        let secondDateComponents = self.dateComponents([.weekOfYear, .month,.weekday, .year, .day], from: secondDate)
        
        guard let firstDateYear = firstDateComponents.year,
              let firstDateDay = firstDateComponents.day,
              let firstDateMonth = firstDateComponents.month,
              
              let secondDateYear = secondDateComponents.year,
              let secondDateDay = secondDateComponents.day,
              let secondDateMonth = secondDateComponents.month
        else { return nil }
//        print("First date  week = \(firstDateWeek), weekDay = \(firstDateWeekDay), year = \(firstDateYear), month = \(firstDateMonth), day = \(firstDateDay)")
//        print("Second date  week = \(secondDateWeek), weekDay = \(secondDateWeekDay), year = \(secondDateYear), month = \(secondDateMonth), day = \(secondDateDay)")
//
//        print(firstDateYear > secondDateYear)
//        print(firstDateMonth > secondDateMonth)
//        print(firstDateDay > secondDateDay)
        
        if firstDateYear < secondDateYear {
            return true
        } else if firstDateYear > secondDateYear {
            return false
        }
        
        if firstDateMonth < secondDateMonth {
            return true
        } else if firstDateMonth > secondDateMonth {
            return false
        }
        
        if firstDateDay < secondDateDay {
            return true
        }
        
        return false
    }
    
    func isDate(date firstDate: Date, inSameDayOrAfter secondDate: Date) -> Bool? {
        let firstDateComponents = self.dateComponents([.weekOfYear, .month,.weekday, .year, .day], from: firstDate)
        let secondDateComponents = self.dateComponents([.weekOfYear, .month,.weekday, .year, .day], from: secondDate)

        guard let firstDateYear = firstDateComponents.year,
              let firstDateDay = firstDateComponents.day,
              let firstDateMonth = firstDateComponents.month,
              let secondDateYear = secondDateComponents.year,
              let secondDateDay = secondDateComponents.day,
              let secondDateMonth = secondDateComponents.month
        else { return nil }
//        print("First date  week = \(firstDateWeek), weekDay = \(firstDateWeekDay), year = \(firstDateYear), month = \(firstDateMonth), day = \(firstDateDay)")
//        print("Second date  week = \(secondDateWeek), weekDay = \(secondDateWeekDay), year = \(secondDateYear), month = \(secondDateMonth), day = \(secondDateDay)")
//
//        print(firstDateYear > secondDateYear)
//        print(firstDateMonth > secondDateMonth)
//        print(firstDateDay > secondDateDay)
        return
            firstDateYear > secondDateYear ||
            firstDateMonth > secondDateMonth ||
            firstDateDay > secondDateDay
    }
    
    func isDate(date firstDate: Date, inSameDayAs secondDate: Date) -> Bool? {
        let firstDateComponents = self.dateComponents([.month, .year, .day], from: firstDate)
        let secondDateComponents = self.dateComponents([.month, .year, .day], from: secondDate)

        guard let firstDateMonth = firstDateComponents.month,
              let firstDateYear = firstDateComponents.year,
              let firstDateDay = firstDateComponents.day,
              let secondDateMonth = secondDateComponents.month,
              let secondDateYear = secondDateComponents.year,
              let secondDateDay = secondDateComponents.day
        else { return nil }
//        print(self.getDescriptionOf(date: firstDate))
//        print(self.getDescriptionOf(date: secondDate))
////        print("First date  week = \(firstDateWeek), weekDay = \(firstDateWeekDay), year = \(firstDateYear), day = \(firstDateDay)")
////        print("Second date  week = \(secondDateWeek), weekDay = \(secondDateWeekDay), year = \(secondDateYear), day = \(secondDateDay)")
//        print("\(firstDateWeek == secondDateWeek) \(firstDateWeekDay == secondDateWeekDay) \(firstDateYear == secondDateYear) \(firstDateDay == secondDateDay)\n")
        
        return
            firstDateMonth == secondDateMonth &&
            firstDateYear == secondDateYear &&
            firstDateDay == secondDateDay
    }
    
    func getWeekDayDescriptionFrom(date : Date) -> String {
        let dayIndex = self.component(.weekday, from: date)
        return self.weekdaySymbols[dayIndex]
    }
    
    func getDescriptionOf(date : Date) -> String {
        let components = self.dateComponents([.weekday,.day,.month,.hour,.minute], from: date)
        let weekDayIndex = components.weekday! - 1
        let monthIndex = components.month! - 1
        let hour = components.hour!
        let minutes = components.minute!
        let weekDayDescription = self.weekdaySymbols[weekDayIndex].capitalized
        let ofConnective = NSLocalizedString("of", comment: "")
        let atConnective = NSLocalizedString("at", comment: "")
        return "\(weekDayDescription), \(components.day!) \(ofConnective) \(self.monthSymbols[monthIndex]) \(atConnective) \(hour):\(minutes)"
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
