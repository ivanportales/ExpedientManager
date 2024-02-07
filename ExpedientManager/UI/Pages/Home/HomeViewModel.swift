//
//  HomeViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/20/24.
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

final class HomeViewModel: ObservableObject {
    
    // MARK: - Binding Properties
    
    @Published private(set) var state: HomeViewModelState = .initial
    
    // MARK: - Exposed Properties
    
    private(set) var scheduledNotificationsDict: [String: [ScheduledNotification]] = [:]
    
    // MARK: - Private Properties
    
    private var dateOfFilter: Date = .init()
    private let getScheduledNotificationsUseCase: GetScheduledNotificationsUseCaseProtocol
    private let getValueForKeyUseCase: GetValueForKeyUseCaseProtocol
    
    // MARK: - Init
    
    init(getScheduledNotificationsUseCase: GetScheduledNotificationsUseCaseProtocol,
         getValueForKeyUseCase: GetValueForKeyUseCaseProtocol) {
        self.getScheduledNotificationsUseCase = getScheduledNotificationsUseCase
        self.getValueForKeyUseCase = getValueForKeyUseCase
    }
    
    // MARK: - Exposed Functions
    
    func filterScheduledDatesWith(date: Date) {
        dateOfFilter = date
        state = .filterContent(filteredScheduledNotifications: getFilteredScheduledDatesWith(date: dateOfFilter))
    }
    
    func getScheduledNotifications() {
        state = .loading
        getScheduledNotificationsUseCase.getScheduledNotifications { [weak self] result in
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
        return date.formateDate(withFormat: "MMMM", dateStyle: .full).firstUppercased
    }
    
    func verifyFirstAccessOnApp(routeToOnboardingCallback: @escaping (() -> Void)) {
        if getValueForKeyUseCase.getValue(forKey: .hasOnboarded) == nil {
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
        return formateDate(withFormat: "MMM dd,yyyy")
    }
}
