//
//  ScheduledNotificationsRepositoryProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 18/01/24.
//

import Foundation

protocol ScheduledNotificationsRepositoryProtocol {
    func save(scheduledNotification: ScheduledNotification,
              completionHandler: @escaping (Result<Bool, Error>) -> ())
    func getAllScheduledNotifications(completionHandler: @escaping (Result<[ScheduledNotification], Error>) -> ())
    func update(scheduledNotification: ScheduledNotification,
                completionHandler: @escaping (Result<Bool, Error>) -> ())
    func delete(scheduledNotification: ScheduledNotification,
                completionHandler: @escaping (Result<Bool, Error>) -> ())
    func deleteAllScheduledNotificationsWhere(scaleUid: String,
                                              completionHandler: @escaping (Result<Bool, Error>) -> ())
}
