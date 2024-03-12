//
//  FixedScale+Extensions.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

extension FixedScale {
    func toData() -> FixedScaleModel {
        return FixedScaleModel(
            id: id,
            title: title ?? "",
            scale: scale!.toData(),
            initialDate: initialDate!,
            finalDate: finalDate!,
            annotation: annotation!,
            colorHex: colorHex!
        )
    }
}

extension FixedScaleModel {
    func toDomain() -> FixedScale {
        return FixedScale(
            id: id,
            title: title ?? "",
            scale: scale!.toDomain(),
            initialDate: initialDate!,
            finalDate: finalDate!,
            annotation: annotation!,
            colorHex: colorHex!
        )
    }
}
