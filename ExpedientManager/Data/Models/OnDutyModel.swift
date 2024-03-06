//
//  OnDutyModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 06/03/24.
//

import Foundation

final class OnDutyModel {
    var id: String
    var titlo: String
    var initialDate: Date
    var hoursDuration: Int
    var annotation: String?
    var colorHex: String?
    
    init(id: String, 
         title: String,
         initialDate: Date,
         hoursDuration: Int,
         annotation: String,
         colorHex: String?) {
        self.id = id
        self.titlo = title
        self.initialDate = initialDate
        self.hoursDuration = hoursDuration
        self.annotation = annotation
        self.colorHex = colorHex
    }
}
