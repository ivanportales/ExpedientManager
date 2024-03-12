//
//  DeleteScheduledNotificationUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

protocol DeleteScheduledNotificationUseCaseProtocol {
    func delete(scheduledNotification: ScheduledNotification, completion: @escaping (Result<Bool, Error>) -> ())
}
