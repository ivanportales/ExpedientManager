//
//  SaveScheduledNotificationUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 13/03/24.
//

import Foundation

final class SaveScheduledNotificationUseCase: SaveScheduledNotificationUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let scheduledNotificationsRepository: ScheduledNotificationRepositoryProtocol
    private let notificationManager: UserNotificationsManagerProtocol
    
    // MARK: - Init
    
    init(scheduledNotificationsRepository: ScheduledNotificationRepositoryProtocol,
         notificationManager: UserNotificationsManagerProtocol) {
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
        self.notificationManager = notificationManager
    }
    
    // MARK: - Exposed Functions
    
    func save(scheduledNotification: ScheduledNotification,
              completion: @escaping (Result<Bool, Error>) -> ()) {
        scheduledNotificationsRepository.save(scheduledNotification: scheduledNotification) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                guard let self = self else { return }
                self.notificationManager.set(scheduledNotification: scheduledNotification,
                                             completion: completion)
            }
        }
    }
}
