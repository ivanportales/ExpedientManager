//
//  UserNotificationsManagerProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 18/01/24.
//

import Foundation

protocol UserNotificationsManagerProtocol {
    func setNotificationIn(minutes : Int)
    func set(scheduledNotification: ScheduledNotification)
    func getAllScheduledNotifications(completion: @escaping ([ScheduledNotification]) -> ())
    func removeAllPendingNotifications()
    func removeAllPendingNotificationsWith(uid: String)
    func askUserNotificationPermission()
}
