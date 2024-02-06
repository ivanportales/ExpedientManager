//
//  HomeViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/20/24.
//

import Foundation

enum HomeVideModelState {
    case initial
    case loading
    case content(scheduledNotificationsDict: [String: [ScheduledNotification]],
                 filteredScheduledNotifications: [ScheduledNotification])
    case filterContent(filteredScheduledNotifications: [ScheduledNotification])
    case error(message: String)
}

final class HomeVideModel: ObservableObject {
    
    // MARK: - Binding Properties
    
    @Published private(set) var state: HomeVideModelState = .initial
    
    // MARK: - Exposed Properties
    
    private(set) var scheduledNotificationsDict: [String: [ScheduledNotification]] = [:]
    
    // MARK: - Private Properties
    
    private var dateOfFilter: Date = .init()
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    private let localStorage: LocalStorageRepositoryProtocol
    private let calendarManager: CalendarManagerProtocol
    
    // MARK: - Init
    
    init(scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol,
         localStorage: LocalStorageRepositoryProtocol,
         calendarManager: CalendarManagerProtocol) {
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
        self.localStorage = localStorage
        self.calendarManager = calendarManager
    }
    
    // MARK: - Exposed Functions
    
    func filterScheduledDatesWith(date: Date) {
        dateOfFilter = date
        state = .filterContent(filteredScheduledNotifications: getFilteredScheduledDatesWith(date: dateOfFilter))
    }
    
    func load() {
        state = .loading
        scheduledNotificationsRepository.getAllScheduledNotifications { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.state = .error(message: error.localizedDescription)
            case .success(let itens):
                var newScheduledScaleDict: [String: [ScheduledNotification]] = [:]
                
                for scheduledScale in itens {
                    let key = scheduledScale.date.dateString
                    if newScheduledScaleDict[key] != nil {
                        newScheduledScaleDict[key]!.append(scheduledScale)
                    } else {
                        newScheduledScaleDict[key] = [scheduledScale]
                    }
                }
                
                self.scheduledNotificationsDict = newScheduledScaleDict
                self.state = .content(
                    scheduledNotificationsDict: newScheduledScaleDict,
                    filteredScheduledNotifications: getFilteredScheduledDatesWith(date: dateOfFilter))
            }
        }
    }
    
    func getMonthDescriptionOf(date: Date) -> String {
        return calendarManager.getMonthDescriptionOf(date: date)
    }
    
    func verifyFirstAccessOnApp(routeToOnboardingCallback: @escaping (() -> Void)) {
        if localStorage.getValue(forKey: .hasOnboarded) == nil {
            routeToOnboardingCallback()
        }
    }
    
    // MARK: - Private Functions
    
    private func getFilteredScheduledDatesWith(date: Date) -> [ScheduledNotification] {
        return scheduledNotificationsDict[date.dateString] ?? []
    }
}

extension Date {
    var dateString: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        return dateFormatterPrint.string(from: self)
    }
}
