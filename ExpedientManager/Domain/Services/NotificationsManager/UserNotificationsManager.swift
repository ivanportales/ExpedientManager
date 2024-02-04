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
    
    func set(scheduledNotification: UserNotificationModel,
             completion: @escaping (Result<Bool, Error>) -> ()) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = Constants.categoryId
        content.title = Constants.appName
        content.subtitle = Constants.notificationSubtitle
        content.userInfo = scheduledNotification.toJson()
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.day,.hour,.month,.minute,.year], 
                                                         from: scheduledNotification.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components , repeats: false)
    
        let request = UNNotificationRequest(identifier: scheduledNotification.uid, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func getAllScheduledNotifications(mapperClosure: @escaping (([String: Any]) -> UserNotificationModel),
                                      completion: @escaping ([UserNotificationModel]) -> ()) {
        var scheduledNotifications = [UserNotificationModel]()
        
        notificationCenter.getPendingNotificationRequests(completionHandler: { notifications in
            if !notifications.isEmpty {
                scheduledNotifications = notifications.compactMap { notification in
                    guard var content = notification.content.userInfo as? [String : Any]
//                          let trigger = notification.trigger as? UNCalendarNotificationTrigger,
//                          let date = trigger.nextTriggerDate() 
                    else {
                        return nil
                    }
                   // content["triggerDate"] = date
                    
                    return mapperClosure(content)
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
                var notificationIdentifiers: [String] = []
                for notification in notifications {
                    let content = notification.content.userInfo as! [String : Any]
                    let contentUid = content["uid"] as? String ?? ""
                    let notificationIdentifier = notification.identifier
                    if contentUid == uid {
                        notificationIdentifiers.append(notificationIdentifier)
                    }
                }
                self?.notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
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
