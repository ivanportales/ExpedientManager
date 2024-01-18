//
//  ScheduledNotification.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 18/01/24.
//

import Foundation

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
