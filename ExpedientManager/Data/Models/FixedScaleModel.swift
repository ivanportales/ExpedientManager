//
//  FixedScaleModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/03/24.
//

import Foundation

final class FixedScaleModel: Codable {
    var id: String
    var title: String?
    var scale: ScaleModel?
    var initialDate: Date?
    var finalDate: Date?
    var annotation: String?
    var colorHex: String?
    
    init(id: String, title: String, scale: ScaleModel, initialDate: Date, finalDate: Date, annotation: String, colorHex: String) {
        self.id = id
        self.title = title
        self.scale = scale
        self.initialDate = initialDate
        self.finalDate = finalDate
        self.annotation = annotation
        self.colorHex = colorHex
    }
}
