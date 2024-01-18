//
//  OnDutyRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/01/24.
//

import Foundation

protocol OnDutyRepositoryProtocol {
    func save(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func getAllOnDuty(completionHandler: @escaping (Result<[OnDuty], Error>) -> ())
    func delete(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func update(onDuty: OnDuty, completionHandler: @escaping (Result<Bool, Error>) -> ())
}
