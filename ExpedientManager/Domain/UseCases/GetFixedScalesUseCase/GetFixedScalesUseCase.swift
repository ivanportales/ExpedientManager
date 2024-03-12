//
//  GetFixedScalesUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 30/01/24.
//

import Foundation

final class GetFixedScalesUseCase: GetFixedScalesUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    
    // MARK: - Init
    
    init(fixedScaleRepository: FixedScaleRepositoryProtocol) {
        self.fixedScaleRepository = fixedScaleRepository
    }
    
    // MARK: - Exposed Functions
    
    func getFixedScales(completionHandler: @escaping (Result<[FixedScale], Error>) -> ()) {
        fixedScaleRepository.getAllFixedScales(completionHandler: completionHandler)
    }
}
