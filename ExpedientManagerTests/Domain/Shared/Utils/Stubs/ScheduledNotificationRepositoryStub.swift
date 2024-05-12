//
//  ScheduledNotificationRepositoryStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 11/05/24.
//

@testable import ExpedientManager

final class ScheduledNotificationRepositoryStub: ScheduledNotificationRepositoryProtocol {
    
    let error: Error?
    let scheduledNotifications: [ScheduledNotification]
    
    init(error: Error? = nil,
         scheduledNotifications: [ScheduledNotification] = []) {
        self.error = error
        self.scheduledNotifications = scheduledNotifications
    }
    
    
    func save(scheduledNotification: ExpedientManager.ScheduledNotification, completionHandler: @escaping (Result<Bool, any Error>) -> ()) {
        // TODO: Implement function
    }
    
    func getAllScheduledNotifications(completionHandler: @escaping (Result<[ExpedientManager.ScheduledNotification], any Error>) -> ()) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(scheduledNotifications))
        }
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
