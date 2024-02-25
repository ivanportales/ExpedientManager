//
//  FixedScale+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 25/02/24.
//

@testable import ExpedientManager
import UIKit

extension FixedScale {
    func toScheduledNotification() -> ScheduledNotification {
        return ScheduledNotification.from(fixedScale: self, with: initialDate ?? .init())
    }
    
    static var mockModels: [FixedScale] {
        var items: [FixedScale] = []
        let colors = UIColor.mockColors

        for index in 0..<10 {
            items.append(FixedScale(id: index.description,
                                    title: "Title FixedScale \(index)",
                                    scale: .init(type: .day,
                                                 scaleOfWork: 12,
                                                 scaleOfRest: 24),
                                    initialDate: Date.customDate(day: index + 1)!,
                                    finalDate: Date.customDate(day: index + 2)!,
                                    annotation: "Annotation \(index)" ,
                                    colorHex: colors[index].hex))
        }
        
        return items
    }
}
