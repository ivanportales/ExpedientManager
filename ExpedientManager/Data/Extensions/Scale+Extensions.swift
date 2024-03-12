//
//  Scale+Extensions.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

extension Scale {
    func toData() -> ScaleModel {
        return ScaleModel(
            type: type.rawValue,
            scaleOfWork: scaleOfWork,
            scaleOfRest: scaleOfRest
        )
    }
}


extension ScaleModel {
    func toDomain() -> Scale {
        return Scale(
            type: ScaleType(rawValue: type) ?? ScaleType.hour,
            scaleOfWork: scaleOfWork,
            scaleOfRest: scaleOfRest
        )
    }
}
