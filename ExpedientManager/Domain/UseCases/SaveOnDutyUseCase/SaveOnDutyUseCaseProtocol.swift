//
//  SaveOnDutyUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 29/01/24.
//

import Foundation

protocol SaveOnDutyUseCaseProtocol {
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ())
}
