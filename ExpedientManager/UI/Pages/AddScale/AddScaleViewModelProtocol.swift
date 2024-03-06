//
//  AddScaleViewModelProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 02/03/24.
//

import Combine
import Foundation

enum AddScaleViewModelState: Equatable {
    case initial
    case loading
    case errorSavingScale(message: String)
    case successSavingScale
}

protocol AddScaleViewModelProtocol {
    var state: Published<AddScaleViewModelState>.Publisher { get }
    
    func save(fixedScale: FixedScale)
    func save(onDuty: OnDuty)
    func requestAuthorizationToSendNotifications()
}
