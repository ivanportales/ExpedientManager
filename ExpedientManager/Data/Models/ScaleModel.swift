//
//  ScaleModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/03/24.
//

import Foundation

final class ScaleModel: Codable {
    var type: String
    var scaleOfWork: Int
    var scaleOfRest: Int
    
    init(type: String, scaleOfWork: Int, scaleOfRest: Int) {
        self.type = type
        self.scaleOfWork = scaleOfWork
        self.scaleOfRest = scaleOfRest
    }
}
