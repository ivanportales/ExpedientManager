//
//  GetScheduledNotificationsUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/02/24.
//

import Foundation

final class GetScheduledNotificationsUseCase: GetScheduledNotificationsUseCaseProtocol {

    // MARK: - Private Properties
    
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    
    // MARK: - Init
    
    init(scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol) {
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
    }
    
    // MARK: - Exposed Functions
 
    func getScheduledNotifications(completion: @escaping (Result<[ScheduledNotification], Error>) -> Void) {
        scheduledNotificationsRepository.getAllScheduledNotifications(completionHandler: completion)
    }
}