//
//  GetScheduledNotificationsUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/02/24.
//

import Foundation

protocol GetScheduledNotificationsUseCaseProtocol {
    func getScheduledNotifications(completion: @escaping (Result<[ScheduledNotification], Error>) -> Void)
}
