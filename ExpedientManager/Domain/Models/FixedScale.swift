//
//  Shift.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/01/24.
//

import Foundation
import UIKit

struct FixedScale: Equatable {
    let id: String
    var title: String?
    var scale: Scale?
    var initialDate: Date?
    var finalDate: Date?
    var annotation: String?
    var colorHex: String?
    
    init(id: String = UUID().uuidString,
         title: String,
         scale: Scale,
         initialDate: Date,
         finalDate: Date,
         annotation: String,
         colorHex: String) {
        self.id = id
        self.title = title
        self.scale = scale
        self.initialDate = initialDate
        self.finalDate = finalDate
        self.annotation = annotation
        self.colorHex = colorHex
    }
}
