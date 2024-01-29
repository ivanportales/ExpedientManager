//
//  SaveFixedScaleUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 29/01/24.
//

import Foundation

protocol SaveFixedScaleUseCaseProtocol {
    func save(fixedScale: FixedScale, completionHandler: @escaping (Result<Bool, Error>) -> ())
}
