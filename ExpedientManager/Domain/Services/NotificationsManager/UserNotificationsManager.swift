//
//  UserNotificationsManager.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 20/01/24.
//

import Foundation
import UserNotifications

final class UserNotificationsManager: UserNotificationsManagerProtocol {
    
    // MARK: - Private Properties
    
    private let notificationCenter : UNUserNotificationCenter
    
    struct Constants {
        static let appName = "iScale"
        static let notificationTitle = "Hoje você tem escala de trabalho!"
        static let notificationSubtitle = ""
        static let notificationBody = ""
        static let categoryId = "myCategory"
    }
    
    // MARK: - Init
    
    init() {
        self.notificationCenter = UNUserNotificationCenter.current()
        
        let category = UNNotificationCategory(
            identifier: Constants.categoryId,
            actions: [
                .init(identifier: "No name", title: NSLocalizedString("", comment: ""), options: .foreground),
                .init(identifier: "Cancelar", title: NSLocalizedString("", comment: ""), options: .destructive)
            ],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([category])
    }
    
    // MARK: - Exposed Functions
    
    func setNotificationIn(minutes : Int) {
        let content = UNMutableNotificationContent()
        content.title = Constants.appName
        content.subtitle = Constants.notificationSubtitle
        content.categoryIdentifier = Constants.categoryId
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(60 * minutes), repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    func set(scheduledNotification: ScheduledNotification) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = Constants.categoryId
        content.title = Constants.appName
        content.subtitle = Constants.notificationSubtitle
        content.userInfo = scheduledNotification.toJson()
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.day,.hour,.month,.minute,.year], from: scheduledNotification.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components , repeats: false)
    
        let request = UNNotificationRequest(identifier:  scheduledNotification.uid, content: content, trigger: trigger)
        
        notificationCenter.add(request) { erro in
            if let message = erro?.localizedDescription {
                print(message)
            }
        }
    }
    
    func getAllScheduledNotifications(completion: @escaping ([ScheduledNotification]) -> ()) {
        var scheduledNotifications = [ScheduledNotification]()
        
        notificationCenter.getPendingNotificationRequests(completionHandler: { notifications in
            if !notifications.isEmpty {
                for notification in notifications {
                    let content = notification.content.userInfo as! [String : Any]
                    let trigger = notification.trigger as! UNCalendarNotificationTrigger
                    let date = trigger.nextTriggerDate() ?? Date()
                    
                    scheduledNotifications.append(
                        ScheduledNotification(
                            uid: content["uid"] as? String ?? "",
                            title: content["title"] as? String  ?? "",
                            description: content["description"] as? String ?? "",
                            date: date,
                            scaleUid: content["scaleUid"] as! String,
                            colorHex: content["colorHex"] as! String
                        )
                    )
                }
            }

            completion(scheduledNotifications)
        })
    }
    
    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func removeAllPendingNotificationsWith(uid: String) {
        notificationCenter.getPendingNotificationRequests { [weak self] notifications in
            if !notifications.isEmpty {
                var notificationsUids: [String] = []
                for notification in notifications {
                    let content = notification.content.userInfo as! [String : Any]
                    let scaleUid = content["scaleUid"] as? String ?? ""
                    let notificationUid = notification.identifier
                    if scaleUid == uid {
                        notificationsUids.append(notificationUid)
                    }
                }
                self?.notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationsUids)
            }
        }
    }
    
    func askUserNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Aceito")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
