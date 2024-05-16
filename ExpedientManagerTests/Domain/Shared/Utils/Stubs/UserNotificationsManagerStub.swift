//
//  UserNotificationsManagerStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 16/05/24.
//

@testable import ExpedientManager

class UserNotificationsManagerStub: UserNotificationsManagerProtocol {
    
    let error: Error?
    let scheduledNotification: [ScheduledNotification]
    
    init(error: Error? = nil,
         scheduledNotification: [ScheduledNotification] = []) {
        self.error = error
        self.scheduledNotification = scheduledNotification
    }
    
    func setNotificationIn(minutes: Int) {
        // TODO: Implement function
    }
    
    func set(scheduledNotification: any ExpedientManager.UserNotificationModel, completion: @escaping (Result<Bool, any Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(true))
        }
    }
    
    func getAllScheduledNotifications(mapperClosure: @escaping (([String : Any]) -> any ExpedientManager.UserNotificationModel), completion: @escaping ([any ExpedientManager.UserNotificationModel]) -> ()) {
        // TODO: Implement function
    }
    
    func removeAllPendingNotifications() {
        // TODO: Implement function
    }
    
    func removeAllPendingNotificationsWith(uid: String) {
        // TODO: Implement function
    }
    
    func askUserNotificationPermission() {
        // TODO: Implement function
    }
}
