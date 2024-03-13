//
//  SaveScheduledNotificationUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 13/03/24.
//

import Foundation

protocol SaveScheduledNotificationUseCaseProtocol {
    func save(scheduledNotification: ScheduledNotification,
              completion: @escaping (Result<Bool, Error>) -> ())
}
