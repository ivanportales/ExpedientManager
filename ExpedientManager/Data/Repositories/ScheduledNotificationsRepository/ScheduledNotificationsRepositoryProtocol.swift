//
//  ScheduledNotificationsRepositoryProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 18/01/24.
//

import Foundation

protocol ScheduledNotificationsRepositoryProtocol {
    func save(scheduledNotification: ScheduledNotificationModel,
              completionHandler: @escaping (Result<Bool, Error>) -> ())
    func getAllScheduledNotifications(completionHandler: @escaping (Result<[ScheduledNotificationModel], Error>) -> ())
    func update(scheduledNotification: ScheduledNotificationModel,
                completionHandler: @escaping (Result<Bool, Error>) -> ())
    func delete(scheduledNotification: ScheduledNotificationModel,
                completionHandler: @escaping (Result<Bool, Error>) -> ())
    func deleteAllScheduledNotificationsWhere(scaleUid: String,
                                              completionHandler: @escaping (Result<Bool, Error>) -> ())
}
