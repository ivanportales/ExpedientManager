//
//  ScalesListViewModelProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 24/02/24.
//

import Foundation

enum ScalesListViewModelStates: Equatable {
    case initial
    case loading
    case content
    case error(message: String)
}

protocol ScalesListViewModelProtocol {
    var state: Published<ScalesListViewModelStates>.Publisher { get }
    var selectedWorkScale: Published<WorkScaleType>.Publisher { get }
    var scheduledNotifications: [ScheduledNotification] { get }

    func getAllScales()
    func change(selectedWorkScale: WorkScaleType)
}
