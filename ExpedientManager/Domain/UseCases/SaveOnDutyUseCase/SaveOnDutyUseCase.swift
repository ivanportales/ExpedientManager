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
    private let saveScheduledNotificationUseCase: SaveScheduledNotificationUseCaseProtocol
    
    // MARK: - Init
    
    init(onDutyRepository: OnDutyRepositoryProtocol,
         saveScheduledNotificationUseCase: SaveScheduledNotificationUseCaseProtocol) {
        self.onDutyRepository = onDutyRepository
        self.saveScheduledNotificationUseCase = saveScheduledNotificationUseCase
    }
    
    // MARK: - Exposed Functions
    
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        onDutyRepository.save(onDuty: onDuty) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(_):
                self.saveScheduledNotificationUseCase.save(scheduledNotification: ScheduledNotification.from(onDuty: onDuty),
                                                           completion: completionHandler)
            }
        }
    }
}
