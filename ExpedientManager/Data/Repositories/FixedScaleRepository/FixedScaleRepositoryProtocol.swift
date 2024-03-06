//
//  ShiftRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 21/01/24.
//

import Foundation

protocol FixedScaleRepositoryProtocol {
    func save(fixedScale: FixedScaleModel, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func getAllFixedScales(completionHandler: @escaping (Result<[FixedScaleModel], Error>) -> ())
    func update(fixedScale: FixedScaleModel, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func delete(fixedScale: FixedScaleModel, completionHandler: @escaping (Result<Bool, Error>) -> ())
}
