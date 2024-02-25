//
//  OnDuty+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 25/02/24.
//

@testable import ExpedientManager
import UIKit

extension OnDuty {
    func toScheduledNotification() -> ScheduledNotification {
        return ScheduledNotification.from(onDuty: self)
    }
    
    static var mockModels: [OnDuty] {
        var items: [OnDuty] = []
        let colors = UIColor.mockColors

        for index in 0..<10 {
            items.append(OnDuty(id: index.description,
                                    title: "Title OnDuty \(index)",
                                    initialDate: Date.customDate(day: index + 1)!,
                                    hoursDuration: 12,
                                    annotation: "Annotation \(index)" ,
                                    colorHex: colors[index].hex))
        }
        
        return items
    }
}
