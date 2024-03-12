//
//  DeleteScheduledNotificationUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

final class DeleteScheduledNotificationUseCase: DeleteScheduledNotificationUseCaseProtocol {

    // MARK: - Private Properties
    
    private let scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol
    
    // MARK: - Init
    
    init(scheduledNotificationsRepository: ScheduledNotificationsRepositoryProtocol) {
        self.scheduledNotificationsRepository = scheduledNotificationsRepository
    }
    
    // MARK: - Exposed Functions
 
    func delete(scheduledNotification: ScheduledNotification, completion: @escaping (Result<Bool, Error>) -> ()) {
        scheduledNotificationsRepository.delete(scheduledNotification: scheduledNotification.toData(),
                                                completionHandler: completion)
    }
}

extension ScheduledNotification {
    func toData() -> ScheduledNotificationModel {
        ScheduledNotificationModel(uid: uid,
                                   title: title,
                                   description: description,
                                   date: date,
                                   scaleUid: scaleUid,
                                   colorHex: colorHex)
    }
}
