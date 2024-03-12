//
//  OnDuty+Extensions.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

extension OnDuty {
    func toData() -> OnDutyModel {
        return OnDutyModel(
            id: id,
            title: titlo,
            initialDate: initialDate,
            hoursDuration: hoursDuration,
            annotation: annotation!,
            colorHex: colorHex!
        )
    }
}

extension OnDutyModel {
    func toDomain() -> OnDuty {
        return OnDuty(
            id: id,
            title: titlo,
            initialDate: initialDate,
            hoursDuration: hoursDuration,
            annotation: annotation!,
            colorHex: colorHex!
        )
    }
}
