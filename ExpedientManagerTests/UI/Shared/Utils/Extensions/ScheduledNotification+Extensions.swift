//
//  ScheduledNotification+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 20/02/24.
//

@testable import ExpedientManager
import UIKit

extension ScheduledNotification {
    static func getModels() -> [ScheduledNotification] {
        var items: [ScheduledNotification] = []
        let colors = [
            UIColor(hex: "#0000FF"),
            UIColor(hex: "#FF2D55"),
            UIColor(hex: "#00FF00"),
            UIColor(hex: "#800080"),
            UIColor(hex: "#FF8000"),
            UIColor(hex: "#101138"),
            UIColor(hex: "#0000FF"),
            UIColor(hex: "#FF2D55"),
            UIColor(hex: "#00FF00"),
            UIColor(hex: "#800080")
        ]

        for index in 0..<10 {
            items.append(ScheduledNotification(uid: index.description,
                                               title: "Title \(index)",
                                               description: "Description \(index)",
                                               date: Date.customDate(day: index + 1)!,
                                               scaleUid: "Scale UID \(index)",
                                               colorHex: colors[index].hex))
        }
        
        return items
    }
}
