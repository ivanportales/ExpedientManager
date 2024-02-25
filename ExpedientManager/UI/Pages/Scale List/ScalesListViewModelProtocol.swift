//
//  ScalesListViewModelProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 24/02/24.
//

import Foundation

enum ScalesListViewModelState: Equatable {
    case initial
    case loading
    case content(scheduledNotifications: [ScheduledNotification],
                 selectedWorkScale: WorkScaleType)
    case error(message: String)
}

protocol ScalesListViewModelProtocol {
    var state: Published<ScalesListViewModelState>.Publisher { get }

    func getAllScales()
    func change(selectedWorkScale: WorkScaleType)
}
