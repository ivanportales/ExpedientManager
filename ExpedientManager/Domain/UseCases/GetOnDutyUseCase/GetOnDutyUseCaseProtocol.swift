//
//  GetOnDutyUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 30/01/24.
//

import Foundation

protocol GetOnDutyUseCaseProtocol {
    func getOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ())
}
