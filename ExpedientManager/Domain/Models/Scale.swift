//
//  Scale.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/03/24.
//

import Foundation

struct Scale: Equatable {
    var type: ScaleType
    var scaleOfWork: Int
    var scaleOfRest: Int
    
    init(type: ScaleType, scaleOfWork: Int, scaleOfRest: Int) {
        self.type = type
        self.scaleOfWork = scaleOfWork
        self.scaleOfRest = scaleOfRest
    }
}
