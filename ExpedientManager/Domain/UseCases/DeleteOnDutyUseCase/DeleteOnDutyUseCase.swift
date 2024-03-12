//
//  DeleteOnDutyUseCase.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/03/24.
//

import Foundation

final class DeleteOnDutyUseCase: DeleteOnDutyUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let onDutyRepository: OnDutyRepositoryProtocol
    
    // MARK: - Init
    
    init(onDutyRepository: OnDutyRepositoryProtocol) {
        self.onDutyRepository = onDutyRepository
    }
    
    // MARK: - Exposed Functions
    
    func delete(onDuty: OnDuty, completion: @escaping (Result<Bool, Error>) -> ()) {
        onDutyRepository.delete(onDuty: onDuty, completionHandler: completion)
    }
}
