//
//  ScheduledNotification.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 18/01/24.
//

import Foundation

struct ScheduledNotification: Equatable {
    var uid: String
    var title: String
    var description: String
    var date: Date
    var scaleUid: String
    var colorHex: String
}

extension ScheduledNotification: UserNotificationModel {
    func toJson() -> [String: Any] {
        return [
            "uid": self.uid ,
            "title": self.title,
            "description": self.description,
            "date": self.date,
            "scaleUid": self.scaleUid,
            "colorHex": self.colorHex
        ]
    }
}

extension ScheduledNotification {
    static func from(fixedScale: FixedScale, with currentDate: Date) -> ScheduledNotification {
        return ScheduledNotification(uid: fixedScale.id,
                                     title: fixedScale.title ?? "",
                                     description: fixedScale.annotation ?? "",
                                     date: currentDate,
                                     scaleUid: fixedScale.id,
                                     colorHex: fixedScale.colorHex!)
    }
    
    static func from(onDuty: OnDuty) -> ScheduledNotification {
        return ScheduledNotification(uid: onDuty.id,
                                     title: onDuty.titlo,
                                     description: onDuty.annotation ?? "",
                                     date: onDuty.initialDate,
                                     scaleUid: onDuty.id,
                                     colorHex: onDuty.colorHex!)
    }
}
