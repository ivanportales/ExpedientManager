//
//  ScheduledNotification.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 18/01/24.
//

import Foundation

//protocol ScheduledNotification {
//    var uid: String { get }
//    var title: String { get }
//    var description: String { get }
//    var date: Date { get }
//    var scaleUid: String { get }
//    var colorHex: String { get }
//    
//    func from(json: [String: Any]) -> ScheduledNotification
//    func toJson() -> [String: Any]
//}
//
//extension ScheduledNotification {
//    func toJson() -> [String: Any] {
//        return [
//            "uid": self.uid ,
//            "title": self.title,
//            "description": self.description,
//            "date": self.date,
//            "scaleUid": self.scaleUid,
//            "colorHex": self.colorHex
//        ]
//    }
//}

struct ScheduledNotification {
    var uid: String
    var title: String
    var description: String
    var date: Date
    var scaleUid: String
    var colorHex: String
    
    static func from(json: [String: Any]) -> ScheduledNotification {
        return ScheduledNotification(
            uid: json["uid"] as! String,
            title: json["title"] as! String,
            description: json["description"] as! String,
            date: json["date"] as? Date ?? .init(),
            scaleUid: json["scaleUid"] as! String,
            colorHex: json["colorHex"] as! String
        )
    }
    
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
        return ScheduledNotification(uid: UUID().uuidString,
                                     title: fixedScale.title ?? "",
                                     description: fixedScale.annotation ?? "",
                                     date: currentDate,
                                     scaleUid: fixedScale.id,
                                     colorHex: fixedScale.colorHex!)
    }
    
    static func from(onDuty: OnDuty) -> ScheduledNotification {
        return ScheduledNotification(uid: UUID().uuidString,
                                     title: onDuty.titlo,
                                     description: onDuty.annotation ?? "",
                                     date: onDuty.initialDate,
                                     scaleUid: onDuty.id,
                                     colorHex: onDuty.colorHex!)
    }
}
