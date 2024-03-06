//
//  OnDutyRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/01/24.
//

import Foundation

protocol OnDutyRepositoryProtocol {
    func save(onDuty: OnDutyModel, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func getAllOnDuty(completionHandler: @escaping (Result<[OnDutyModel], Error>) -> ())
    func delete(onDuty: OnDutyModel, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func update(onDuty: OnDutyModel, completionHandler: @escaping (Result<Bool, Error>) -> ())
}
