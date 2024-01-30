//
//  SaveOnDutyUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 29/01/24.
//

import Foundation

final class SaveOnDutyUseCase: SaveOnDutyUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let onDutyRepository: OnDutyRepositoryProtocol
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    private let notificationManager: UserNotificationsManagerProtocol
    
    // MARK: - Init
    
    init(onDutyRepository: OnDutyRepositoryProtocol,
         scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol,
         notificationManager: UserNotificationsManagerProtocol) {
        self.onDutyRepository = onDutyRepository
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
        self.notificationManager = notificationManager
    }
    
    // MARK: - Exposed Functions
    
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        onDutyRepository.save(onDuty: onDuty) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(_):
                self.set(scheduledNotification: ScheduledNotification.from(onDuty: onDuty))
            }
        }
    }
    
    // MARK: - Private Properties
    
    private func set(scheduledNotification: ScheduledNotification) {
        scheduledNotificationsRepository.save(scheduledNotification: scheduledNotification) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(_):
                guard let self = self else {return}
                self.notificationManager.set(scheduledNotification: scheduledNotification)
            }
        }
    }
}
