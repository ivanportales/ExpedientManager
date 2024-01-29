//
//  CalendarManager.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 25/01/24.
//

import Foundation

protocol CalendarManagerProtocol {
    func combineTimeFrom(_ firstDate: Date, andDateFrom secondDate: Date) -> Date
}

extension Calendar: CalendarManagerProtocol {}
