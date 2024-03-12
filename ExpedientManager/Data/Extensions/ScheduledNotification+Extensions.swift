//
//  ScheduledNotification+Extensions.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

extension ScheduledNotification {
    func toData() -> ScheduledNotificationModel {
        ScheduledNotificationModel(uid: uid,
                                   title: title,
                                   description: description,
                                   date: date,
                                   scaleUid: scaleUid,
                                   colorHex: colorHex)
    }
}

extension ScheduledNotificationModel {
    func toDomain() -> ScheduledNotification {
        ScheduledNotification(uid: uid,
                                   title: title,
                                   description: description,
                                   date: date,
                                   scaleUid: scaleUid,
                                   colorHex: colorHex)
    }
}
