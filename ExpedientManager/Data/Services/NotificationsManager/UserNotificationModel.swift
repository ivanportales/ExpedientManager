//
//  UserNotificationModel.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 02/02/24.
//

import Foundation

protocol UserNotificationModel {
    var uid: String { get }
    var title: String { get }
    var description: String { get }
    var date: Date { get }
   
    func toJson() -> [String: Any]
}
