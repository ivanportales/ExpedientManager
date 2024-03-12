//
//  DeleteScheduledNotificationUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

final class DeleteScheduledNotificationUseCase: DeleteScheduledNotificationUseCaseProtocol {

    // MARK: - Private Properties
    
    private let scheduledNotificationsRepository: ScheduledNotificationRepositoryProtocol
    
    // MARK: - Init
    
    init(scheduledNotificationsRepository: ScheduledNotificationRepositoryProtocol) {
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
    }
    
    // MARK: - Exposed Functions
 
    func delete(scheduledNotification: ScheduledNotification, completion: @escaping (Result<Bool, Error>) -> ()) {
        scheduledNotificationsRepository.delete(scheduledNotification: scheduledNotification,
                                                completionHandler: completion)
    }
}
