//
//  ScheduledNotificationModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

struct ScheduledNotificationModel: Equatable {
    var uid: String
    var title: String
    var description: String
    var date: Date
    var scaleUid: String
    var colorHex: String
}
