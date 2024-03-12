//
//  DeleteFixedScaleUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

final class DeleteFixedScaleUseCase: DeleteFixedScaleUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let fixedScaleRepository: FixedScaleRepositoryProtocol
    
    // MARK: - Init
    
    init(fixedScaleRepository: FixedScaleRepositoryProtocol) {
        self.fixedScaleRepository = fixedScaleRepository
    }
    
    // MARK: - Exposed Functions
    
    func delete(fixedScale: FixedScale, completion: @escaping (Result<Bool, Error>) -> ()) {
        fixedScaleRepository.delete(fixedScale: fixedScale, completionHandler: completion)
    }
}
