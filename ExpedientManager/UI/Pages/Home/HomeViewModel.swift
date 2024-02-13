//
//  HomeViewModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/11/23.
//

import Foundation

final class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    
    // MARK: - Binding Properties
    
    @Published private(set) var statePublished: HomeViewModelState = .initial
    var state: Published<HomeViewModelState>.Publisher { $statePublished }
    
    // MARK: - Private Properties
    
    private var scheduledNotificationsDict: [String: [ScheduledNotification]] = [:]
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
    
    func fetchScheduledNotifications() {
        statePublished = .loading
        getScheduledNotificationsUseCase.getScheduledNotifications { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.statePublished = .error(message: error.localizedDescription)
            case .success(let scheduledNotifications):
                self.scheduledNotificationsDict = Dictionary(grouping: scheduledNotifications,
                                                             by: { self.key(forDate:$0.date) })
                self.statePublished = .content(
                    notificationsCount: self.scheduledNotificationsDict.values.count,
                    filteredNotifications: getFilteredScheduledDatesWith(date: dateOfFilter))
            }
        }
    }
    
    func getFilteredScheduledDatesWith(date: Date) -> [ScheduledNotification] {
        return scheduledNotificationsDict[key(forDate: date)] ?? []
    }
    
    func getMonthDescriptionOf(date: Date) -> String {
        return date.formateDate(withFormat: "MMMM", dateStyle: .full).firstUppercased
    }
    
    func filterScheduledDatesWith(date: Date) {
        dateOfFilter = date
        statePublished = .filterContent(filteredNotifications: getFilteredScheduledDatesWith(date: dateOfFilter))
    }
    
    func verifyFirstAccessOnApp(routeToOnboardingCallback: @escaping (() -> Void)) {
        if getValueForKeyUseCase.getValue(forKey: .hasOnboarded) == nil {
            routeToOnboardingCallback()
        }
    }
    
    // MARK: - Private Functions
    
    private func key(forDate date: Date) -> String {
        return date.formateDate(withFormat: "MMM dd,yyyy")
    }
}
