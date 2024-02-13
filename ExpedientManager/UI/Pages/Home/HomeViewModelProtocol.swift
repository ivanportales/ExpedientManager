//
//  HomeViewModelProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 12/02/24.
//

import Foundation

enum HomeViewModelState {
    case initial
    case loading
    case content(scheduledNotificationsDict: [String: [ScheduledNotification]],
                 filteredScheduledNotifications: [ScheduledNotification])
    case filterContent(filteredScheduledNotifications: [ScheduledNotification])
    case error(message: String)
}

protocol HomeViewModelProtocol {
    var state: Published<HomeViewModelState>.Publisher { get }
    
    func fetchScheduledNotifications()
    func getFilteredScheduledDatesWith(date: Date) -> [ScheduledNotification]
    func getMonthDescriptionOf(date: Date) -> String
    func filterScheduledDatesWith(date: Date)
    func verifyFirstAccessOnApp(routeToOnboardingCallback: @escaping (() -> Void))
}
