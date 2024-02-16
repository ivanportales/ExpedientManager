//
//  GetScheduledNotificationsUseCaseStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 15/02/24.
//

@testable import ExpedientManager

final class GetScheduledNotificationsUseCaseStub: GetScheduledNotificationsUseCaseProtocol {
    
    let scheduledNotifications: [ScheduledNotification]
    let error: Error?
    
    init(scheduledNotifications: [ScheduledNotification] = [],
         error: Error? = nil) {
        self.scheduledNotifications = scheduledNotifications
        self.error = error
    }
    
    func getScheduledNotifications(completion: @escaping (Result<[ScheduledNotification], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(scheduledNotifications))
        }
    }
}
