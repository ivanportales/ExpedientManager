//
//  ShiftRepository.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 21/01/24.
//

import Foundation

protocol FixedScaleRepositoryProtocol {
    func save(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func getAllFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ())
    func delete(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ())
    func update(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ())
}
