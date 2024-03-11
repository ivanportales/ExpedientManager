//
//  DeleteFixedScaleUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

protocol DeleteFixedScaleUseCaseProtocol {
    func delete(fixedScale: FixedScale, completion: @escaping (Result<Bool, Error>) -> ())
}
