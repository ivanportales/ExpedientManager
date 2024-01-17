//
//  OnDutyRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/01/24.
//

import Foundation

protocol OnDutyRepository {
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func getAllOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ())
    func delete(onDuty: OnDuty) -> Result<Bool, Error>
    func update(onDuty: OnDuty) -> Result<Bool, Error>
}
