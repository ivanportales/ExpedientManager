//
//  UserNotificationsManagerStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 16/05/24.
//

@testable import ExpedientManager

class UserNotificationsManagerStub: ScheduledNotificationRepositoryProtocol {
    
    let error: Error?
    let scheduledNotification: [ScheduledNotification]
    
    init(error: Error? = nil,
         scheduledNotification: [ScheduledNotification] = []) {
        self.error = error
        self.scheduledNotification = scheduledNotification
    }
    
    var shouldFailOnSave = false

    func save(scheduledNotification: ScheduledNotification, completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(true))
        }
    }
    
    func getAllScheduledNotifications(completionHandler: @escaping (Result<[ExpedientManager.ScheduledNotification], any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func update(scheduledNotification: ExpedientManager.ScheduledNotification, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func delete(scheduledNotification: ExpedientManager.ScheduledNotification, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func deleteAllScheduledNotificationsWhere(scaleUid: String, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
}
