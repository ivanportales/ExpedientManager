//
//  GetFixedScalesUseCaseProtocol.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 30/01/24.
//

import Foundation

protocol GetFixedScalesUseCaseProtocol {
    func getFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ())
}
