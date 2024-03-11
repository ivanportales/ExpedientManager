//
//  DeleteOnDutyUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

protocol DeleteOnDutyUseCaseProtocol {
    func delete(onDuty: OnDuty, completion: @escaping (Result<Bool, Error>) -> ())
}
