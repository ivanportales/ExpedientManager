//
//  CalendarManager.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 25/01/24.
//

import Foundation

protocol CalendarManagerProtocol {
    func combineTimeFrom(_ firstDate: Date, andDateFrom secondDate: Date) -> Date
    func isDate(_ firstDate: Date, before secondDate: Date) -> Bool
    func isDate(_ firstDate: Date, inSameDayOrAfter secondDate: Date) -> Bool
    func add(_ value: Int, to component: Calendar.Component, ofDate date: Date) -> Date
    func getWeekDayDescriptionFrom(date : Date) -> String
    func getDescriptionOf(date: Date) -> String
    func getHourAndMinuteFrom(date : Date) -> String
    func getDayAndMonthFrom(date : Date) -> String
    func getMonthDescriptionOf(date: Date) -> String
}

extension Calendar: CalendarManagerProtocol {}
