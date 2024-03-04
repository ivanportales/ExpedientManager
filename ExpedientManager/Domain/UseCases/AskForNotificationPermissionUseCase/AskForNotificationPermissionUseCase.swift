//
//  AskForNotificationPermissionUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 04/03/24.
//

import Foundation

final class AskForNotificationPermissionUseCase: AskForNotificationPermissionUseCaseProtocol {
    
    private let notificationsManager: UserNotificationsManagerProtocol
    
    init(notificationsManager: UserNotificationsManagerProtocol) {
        self.notificationsManager = notificationsManager
    }
    
    func askForNotificationPermission() {
        notificationsManager.askUserNotificationPermission()
    }
}
